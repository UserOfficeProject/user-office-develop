#!/usr/bin/env bash

set -e

export REPO_DIR="repositories"

export USER_OFFICE_GATEWAY_DIR="$REPO_DIR/user-office-gateway"

export USER_OFFICE_FRONTEND_DIR="$REPO_DIR/user-office-frontend"
export USER_OFFICE_BACKEND_DIR="$REPO_DIR/user-office-backend"

export USER_OFFICE_SCHEDULER_FRONTEND_DIR="$REPO_DIR/user-office-scheduler-frontend"
export USER_OFFICE_SCHEDULER_BACKEND_DIR="$REPO_DIR/user-office-scheduler-backend"

setup_user_office_gateway() {
  rm -rf "$USER_OFFICE_GATEWAY_DIR"
  git clone git@github.com:UserOfficeProject/user-office-gateway.git --depth 1 "$USER_OFFICE_GATEWAY_DIR"
}

setup_user_office_frontend() {
  rm -rf "$USER_OFFICE_FRONTEND_DIR"
  git clone git@github.com:UserOfficeProject/user-office-frontend.git --depth 1 "$USER_OFFICE_FRONTEND_DIR"
}

setup_user_office_backend() {
  rm -rf "$USER_OFFICE_BACKEND_DIR"
  git clone git@github.com:UserOfficeProject/user-office-backend.git --depth 1 "$USER_OFFICE_BACKEND_DIR"
}

setup_user_office_scheduler_frontend() {
  rm -rf "$USER_OFFICE_SCHEDULER_FRONTEND_DIR"
  git clone git@github.com:UserOfficeProject/user-office-scheduler-frontend.git --depth 1 "$USER_OFFICE_SCHEDULER_FRONTEND_DIR"
}

setup_user_office_scheduler_backend() {
  rm -rf "$USER_OFFICE_SCHEDULER_BACKEND_DIR"
  git clone git@github.com:UserOfficeProject/user-office-scheduler-backend.git --depth 1 "$USER_OFFICE_SCHEDULER_BACKEND_DIR"
}

clean_repositories() {
  rm -rf "$REPO_DIR"
}

case $1 in
  clean)
    clean_repositories 
  ;;

  setup:all)
    setup_user_office_gateway
    setup_user_office_frontend
    setup_user_office_backend
    setup_user_office_scheduler_frontend
    setup_user_office_scheduler_backend
  ;;
  down:all)
    docker-compose \
      -f docker-compose.all.yml \
      -f "$USER_OFFICE_FRONTEND_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_BACKEND_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_GATEWAY_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_SCHEDULER_BACKEND_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_SCHEDULER_FRONTEND_DIR/docker-compose.dev.yml" \
      down -v --rmi local
  ;;
  up:all)
    docker-compose \
      -f docker-compose.all.yml \
      -f "$USER_OFFICE_FRONTEND_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_BACKEND_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_GATEWAY_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_SCHEDULER_BACKEND_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_SCHEDULER_FRONTEND_DIR/docker-compose.dev.yml" \
      up -d --build
  ;;

  setup:user-office)
    setup_user_office_gateway
    setup_user_office_frontend
    setup_user_office_backend
  ;;
  down:user-office)
    docker-compose \
      -f docker-compose.all.yml \
      -f "$USER_OFFICE_FRONTEND_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_BACKEND_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_GATEWAY_DIR/docker-compose.dev.yml" \
      down -v --rmi local
  ;;
  up:user-office)
    if [[ -z "$USER_OFFICE_SCHEDULER_BACKEND" ]]; then
      export USER_OFFICE_SCHEDULER_BACKEND="http://host.docker.internal:4000/graphql"
    fi

    docker-compose \
      -f docker-compose.all.yml \
      -f "$USER_OFFICE_FRONTEND_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_BACKEND_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_GATEWAY_DIR/docker-compose.dev.yml" \
      up -d --build
  ;;

  setup:scheduler)
    setup_user_office_gateway
    setup_user_office_frontend
    setup_user_office_backend
    setup_user_office_scheduler_frontend
    setup_user_office_scheduler_backend
  ;;
  down:scheduler)
    docker-compose \
      -f docker-compose.all.yml \
      -f "$USER_OFFICE_GATEWAY_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_SCHEDULER_BACKEND_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_SCHEDULER_FRONTEND_DIR/docker-compose.dev.yml" \
      down -v --rmi local
  ;;
  up:scheduler)
    if [[ -z "$USER_OFFICE_BACKEND" ]]; then
      export USER_OFFICE_BACKEND="http://host.docker.internal:4000/graphql"
    fi

    docker-compose \
      -f docker-compose.all.yml \
      -f "$USER_OFFICE_GATEWAY_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_SCHEDULER_BACKEND_DIR/docker-compose.dev.yml" \
      -f "$USER_OFFICE_SCHEDULER_FRONTEND_DIR/docker-compose.dev.yml" \
      up -d --build
  ;;

  *)
  echo "Unkown command"
  ;;
esac

# User office dev environment

The goal of this repo is to be able to set up and run all or parts of the user office services, so now or in the future the developers can run each or a part of the application easily while working on other parts of it.

## Usage

### All services

Before using any service, you have to set up the services you want to use,
to do so use the command:

```bash
$ ./run.sh setup:all
```

> The `run.sh` has to be executable (`chmod +x run.sh`)

This will clone the last version of the default branch from each repositories.

To launch all services:

```bash
$ ./run.sh up:all
```

To terminate the running services:

```bash
$ ./run.sh down:all
```

To clean up and remove the copy of all existing repositories:

```bash
$ ./run.sh clean
```

### User office only

To run only the user office services (so you can e.g. focus on developing scheduler), you can use the command:

```bash
# this will only clone the repositories needed to run user office services
$ ./run.sh setup:user-office
```

To launch user office services:

```bash
# this assumes the scheduler backend is running on localhost:4000/graphql
$ ./run.sh up:user-office

# to change the scheduler backend endpoint, run the command with the environment variable
$ USER_OFFICE_SCHEDULER_BACKEND=http://localhost:9999/graphql ./run.sh up:user-office
```

To terminate the running services:

```bash
$ ./run.sh down:user-office
```

### Scheduler only

To run only the scheduler services (so you can e.g. focus on developing the user office), you can use the command:

```bash
# this will only clone the repositories needed to run scheduler services
$ ./run.sh setup:scheduler
```

To launch user scheduler services:

```bash
# this assumes the user office backend is running on localhost:4000/graphql
$ ./run.sh up:scheduler

# to change the user office backend endpoint, run the command with the environment variable
$ USER_OFFICE_BACKEND=http://localhost:9999/graphql ./run.sh up:scheduler
```

To terminate the running services:

```bash
$ ./run.sh down:scheduler
```

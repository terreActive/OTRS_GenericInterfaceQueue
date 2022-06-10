# NAME

GenericInterfaceQueue.opm - Implement Queue functions for Webservices

# VERSION

version 6.0.0

# DESCRIPTION

The free version of OTRS 6 implements only a subset of its internal API also as
GenericInterface for use by webservices (REST and SOAP APIs).

This Add-on implements some Kernel::System::Queue functions as
Kernel::GenericInterface::Operation::Queue enabling the creation of webservices
with a few mouse clicks.

# INSTALLATION

```sh
    bin/otrs.Console.pl Admin::Package::Install GenericInterfaceQueue.opm
```

Or use the GUI: Admin -> Package Manager

# CONFIGURATION

There are only a few configuration items:

```
    GenericInterface::Operation::QueueSearch###SearchLimit => 100
```

# BUILD

The repository provides a SOPM file. Building an OPM package is outside the
scope of a Readme.


# DEVELOPMENT

This is free software. It resides on GitHub at

```
    https://github.com/terreActive/OTRS_GenericInterfaceQueue.git
```

Feel free to improve it and submit pull requests.

# AUTHOR

Othmar Wigger <othmar.wigger@terreactive.ch>


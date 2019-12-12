# ECF Generator

## Goal
Create an Eiffel library of data, business, and interface tier classes, which allow a user to either create or modify an existing ECF configuration file that will successfully complete the WrapC/UI results, such that a user of WrapC/UI can easily consume and use the results of WrapC/UI in a target ECF project.

## Inputs
The code is being designed against standard Eiffel ECF XML files. Therefore—it is designed to successfully read and parse ECF XML into an internal data structure, which is then used to facilitate the goal (above). The {GENERIC_XML_CALLBACK_HANDLER} class (for example) can be used to generically read and parse XML other than ECF files. However, in this project, we are only concerned with ECF files.

## Processes
Business and interface code is primarily concerned with allowing a user to either create a new ECF file or modify an existing ECF file to configure it to consume the outputs of a WrapC/UI process result. Thus, this code takes up where WrapC/UI code ends, taking its work-product results and configuring an ECF project to consume them, which takes the user all the way to the ultimate goal (using the C code in Eiffel).

The business logic is about setting up the configuration in memory in preparation for outputting (below) to an ECF file. The interface logic is about facilitating a GUI to access and manipulate the business processes and logic based on the control of the user. These GUI classes are constructed for either consumption as a library in other Eiffel projects -OR- as a stand-alone finalized EXE product. Either way, the goal is the same.

## Outputs
As already stated—the output of the code in this project is always an ECF configured to successfully consume the results of a WrapC/UI processing session. There is no other output—not even a "Save" feature. Why? Because all the data that would be placed into a "Save"-file will be found in the output ECF file, which can be read back in, the data retrieved, and the "state" restored. Therefore, a "Save"-file is not required.

# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canoncical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = "/Applications/CMake 2.8-1.app/Contents/bin/cmake"

# The command to remove a file.
RM = "/Applications/CMake 2.8-1.app/Contents/bin/cmake" -E remove -f

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = "/Applications/CMake 2.8-1.app/Contents/bin/ccmake"

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/cdcorrea/Research/ngl/qhull

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/cdcorrea/Research/ngl/qhull/build

# Include any dependencies generated for this target.
include CMakeFiles/qdelaunay.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/qdelaunay.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/qdelaunay.dir/flags.make

CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o: CMakeFiles/qdelaunay.dir/flags.make
CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o: ../src/qdelaunay/qdelaun.c
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/cdcorrea/Research/ngl/qhull/build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building C object CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o"
	/usr/bin/gcc  $(C_DEFINES) $(C_FLAGS) -o CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o   -c /Users/cdcorrea/Research/ngl/qhull/src/qdelaunay/qdelaun.c

CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.i"
	/usr/bin/gcc  $(C_DEFINES) $(C_FLAGS) -E /Users/cdcorrea/Research/ngl/qhull/src/qdelaunay/qdelaun.c > CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.i

CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.s"
	/usr/bin/gcc  $(C_DEFINES) $(C_FLAGS) -S /Users/cdcorrea/Research/ngl/qhull/src/qdelaunay/qdelaun.c -o CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.s

CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o.requires:
.PHONY : CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o.requires

CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o.provides: CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o.requires
	$(MAKE) -f CMakeFiles/qdelaunay.dir/build.make CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o.provides.build
.PHONY : CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o.provides

CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o.provides.build: CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o
.PHONY : CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o.provides.build

# Object files for target qdelaunay
qdelaunay_OBJECTS = \
"CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o"

# External object files for target qdelaunay
qdelaunay_EXTERNAL_OBJECTS =

qdelaunay: CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o
qdelaunay: libqhullstatic.a
qdelaunay: CMakeFiles/qdelaunay.dir/build.make
qdelaunay: CMakeFiles/qdelaunay.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking C executable qdelaunay"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/qdelaunay.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/qdelaunay.dir/build: qdelaunay
.PHONY : CMakeFiles/qdelaunay.dir/build

CMakeFiles/qdelaunay.dir/requires: CMakeFiles/qdelaunay.dir/src/qdelaunay/qdelaun.c.o.requires
.PHONY : CMakeFiles/qdelaunay.dir/requires

CMakeFiles/qdelaunay.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/qdelaunay.dir/cmake_clean.cmake
.PHONY : CMakeFiles/qdelaunay.dir/clean

CMakeFiles/qdelaunay.dir/depend:
	cd /Users/cdcorrea/Research/ngl/qhull/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/cdcorrea/Research/ngl/qhull /Users/cdcorrea/Research/ngl/qhull /Users/cdcorrea/Research/ngl/qhull/build /Users/cdcorrea/Research/ngl/qhull/build /Users/cdcorrea/Research/ngl/qhull/build/CMakeFiles/qdelaunay.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/qdelaunay.dir/depend

# Install script for directory: /home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/nvidia/ros_ws/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/baxter_core_msgs/msg" TYPE FILE FILES
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/AnalogIOState.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/AnalogIOStates.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/AnalogOutputCommand.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/AssemblyState.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/AssemblyStates.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/CameraControl.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/CameraSettings.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/CollisionAvoidanceState.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/CollisionDetectionState.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/DigitalIOState.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/DigitalIOStates.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/DigitalOutputCommand.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/EndEffectorCommand.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/EndEffectorProperties.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/EndEffectorState.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/EndpointState.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/EndpointStates.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/HeadPanCommand.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/HeadState.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/JointCommand.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/NavigatorState.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/NavigatorStates.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/RobustControllerStatus.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/SEAJointState.msg"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg/URDFConfiguration.msg"
    )
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/baxter_core_msgs/srv" TYPE FILE FILES
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/srv/CloseCamera.srv"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/srv/ListCameras.srv"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/srv/OpenCamera.srv"
    "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/srv/SolvePositionIK.srv"
    )
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/baxter_core_msgs/cmake" TYPE FILE FILES "/home/nvidia/ros_ws/build/baxter_common/baxter_core_msgs/catkin_generated/installspace/baxter_core_msgs-msg-paths.cmake")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/home/nvidia/ros_ws/devel/include/baxter_core_msgs")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/roseus/ros" TYPE DIRECTORY FILES "/home/nvidia/ros_ws/devel/share/roseus/ros/baxter_core_msgs")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/common-lisp/ros" TYPE DIRECTORY FILES "/home/nvidia/ros_ws/devel/share/common-lisp/ros/baxter_core_msgs")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/gennodejs/ros" TYPE DIRECTORY FILES "/home/nvidia/ros_ws/devel/share/gennodejs/ros/baxter_core_msgs")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  execute_process(COMMAND "/usr/bin/python" -m compileall "/home/nvidia/ros_ws/devel/lib/python2.7/dist-packages/baxter_core_msgs")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python2.7/dist-packages" TYPE DIRECTORY FILES "/home/nvidia/ros_ws/devel/lib/python2.7/dist-packages/baxter_core_msgs")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/nvidia/ros_ws/build/baxter_common/baxter_core_msgs/catkin_generated/installspace/baxter_core_msgs.pc")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/baxter_core_msgs/cmake" TYPE FILE FILES "/home/nvidia/ros_ws/build/baxter_common/baxter_core_msgs/catkin_generated/installspace/baxter_core_msgs-msg-extras.cmake")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/baxter_core_msgs/cmake" TYPE FILE FILES
    "/home/nvidia/ros_ws/build/baxter_common/baxter_core_msgs/catkin_generated/installspace/baxter_core_msgsConfig.cmake"
    "/home/nvidia/ros_ws/build/baxter_common/baxter_core_msgs/catkin_generated/installspace/baxter_core_msgsConfig-version.cmake"
    )
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/baxter_core_msgs" TYPE FILE FILES "/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/package.xml")
endif()


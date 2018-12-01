// Generated by gencpp from file baxter_core_msgs/RobustControllerStatus.msg
// DO NOT EDIT!


#ifndef BAXTER_CORE_MSGS_MESSAGE_ROBUSTCONTROLLERSTATUS_H
#define BAXTER_CORE_MSGS_MESSAGE_ROBUSTCONTROLLERSTATUS_H


#include <string>
#include <vector>
#include <map>

#include <ros/types.h>
#include <ros/serialization.h>
#include <ros/builtin_message_traits.h>
#include <ros/message_operations.h>


namespace baxter_core_msgs
{
template <class ContainerAllocator>
struct RobustControllerStatus_
{
  typedef RobustControllerStatus_<ContainerAllocator> Type;

  RobustControllerStatus_()
    : isEnabled(false)
    , complete(0)
    , controlUid()
    , timedOut(false)
    , errorCodes()
    , labels()  {
    }
  RobustControllerStatus_(const ContainerAllocator& _alloc)
    : isEnabled(false)
    , complete(0)
    , controlUid(_alloc)
    , timedOut(false)
    , errorCodes(_alloc)
    , labels(_alloc)  {
  (void)_alloc;
    }



   typedef uint8_t _isEnabled_type;
  _isEnabled_type isEnabled;

   typedef int32_t _complete_type;
  _complete_type complete;

   typedef std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other >  _controlUid_type;
  _controlUid_type controlUid;

   typedef uint8_t _timedOut_type;
  _timedOut_type timedOut;

   typedef std::vector<std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other > , typename ContainerAllocator::template rebind<std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other > >::other >  _errorCodes_type;
  _errorCodes_type errorCodes;

   typedef std::vector<std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other > , typename ContainerAllocator::template rebind<std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other > >::other >  _labels_type;
  _labels_type labels;



  enum {
    NOT_COMPLETE = 0,
    COMPLETE_W_FAILURE = 1,
    COMPLETE_W_SUCCESS = 2,
  };


  typedef boost::shared_ptr< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> > Ptr;
  typedef boost::shared_ptr< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> const> ConstPtr;

}; // struct RobustControllerStatus_

typedef ::baxter_core_msgs::RobustControllerStatus_<std::allocator<void> > RobustControllerStatus;

typedef boost::shared_ptr< ::baxter_core_msgs::RobustControllerStatus > RobustControllerStatusPtr;
typedef boost::shared_ptr< ::baxter_core_msgs::RobustControllerStatus const> RobustControllerStatusConstPtr;

// constants requiring out of line definition

   

   

   



template<typename ContainerAllocator>
std::ostream& operator<<(std::ostream& s, const ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> & v)
{
ros::message_operations::Printer< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> >::stream(s, "", v);
return s;
}

} // namespace baxter_core_msgs

namespace ros
{
namespace message_traits
{



// BOOLTRAITS {'IsFixedSize': False, 'IsMessage': True, 'HasHeader': False}
// {'std_msgs': ['/opt/ros/kinetic/share/std_msgs/cmake/../msg'], 'sensor_msgs': ['/opt/ros/kinetic/share/sensor_msgs/cmake/../msg'], 'geometry_msgs': ['/opt/ros/kinetic/share/geometry_msgs/cmake/../msg'], 'baxter_core_msgs': ['/home/nvidia/ros_ws/src/baxter_common/baxter_core_msgs/msg']}

// !!!!!!!!!!! ['__class__', '__delattr__', '__dict__', '__doc__', '__eq__', '__format__', '__getattribute__', '__hash__', '__init__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', '_parsed_fields', 'constants', 'fields', 'full_name', 'has_header', 'header_present', 'names', 'package', 'parsed_fields', 'short_name', 'text', 'types']




template <class ContainerAllocator>
struct IsFixedSize< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> >
  : FalseType
  { };

template <class ContainerAllocator>
struct IsFixedSize< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> const>
  : FalseType
  { };

template <class ContainerAllocator>
struct IsMessage< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> >
  : TrueType
  { };

template <class ContainerAllocator>
struct IsMessage< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> const>
  : TrueType
  { };

template <class ContainerAllocator>
struct HasHeader< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> >
  : FalseType
  { };

template <class ContainerAllocator>
struct HasHeader< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> const>
  : FalseType
  { };


template<class ContainerAllocator>
struct MD5Sum< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> >
{
  static const char* value()
  {
    return "2f15441b7285d915e7e59d3618e173f2";
  }

  static const char* value(const ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator>&) { return value(); }
  static const uint64_t static_value1 = 0x2f15441b7285d915ULL;
  static const uint64_t static_value2 = 0xe7e59d3618e173f2ULL;
};

template<class ContainerAllocator>
struct DataType< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> >
{
  static const char* value()
  {
    return "baxter_core_msgs/RobustControllerStatus";
  }

  static const char* value(const ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator>&) { return value(); }
};

template<class ContainerAllocator>
struct Definition< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> >
{
  static const char* value()
  {
    return "# True if the RC is enabled and running, false if not.\n\
bool isEnabled\n\
\n\
# The state of the RC with respect to its completion goal.  One of\n\
# NOT_COMPLETE, COMPLETE_W_FAILURE, or COMPLETE_W_SUCCESS\n\
int32 complete\n\
int32 NOT_COMPLETE = 0\n\
int32 COMPLETE_W_FAILURE = 1\n\
int32 COMPLETE_W_SUCCESS = 2\n\
\n\
# Identifies the sender of the Enable message that the RC is using for its\n\
# commands.  This should correspond to the \"uid\" field of a recently published\n\
# RC *Enable message.\n\
string controlUid\n\
\n\
# Set to true when the RC self-disables as a result of too much time elapsing\n\
# without receiving an Enable message.\n\
bool timedOut\n\
\n\
# A list of relevant error codes.  Error codes are defined by the individual\n\
# robust controllers, consult a robust controller's documentation to see what\n\
# error codes it generates.\n\
string[] errorCodes\n\
\n\
# A list of current labels for the RC's current state. For example, \"fastapproach\",\n\
# \"slowapproach\", etc. Used primarily for the blended RCs, other RCs can leave this\n\
# blank. This will probably contains just one label, but it could contain multiple labels\n\
# in the future.\n\
string[] labels\n\
";
  }

  static const char* value(const ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator>&) { return value(); }
};

} // namespace message_traits
} // namespace ros

namespace ros
{
namespace serialization
{

  template<class ContainerAllocator> struct Serializer< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> >
  {
    template<typename Stream, typename T> inline static void allInOne(Stream& stream, T m)
    {
      stream.next(m.isEnabled);
      stream.next(m.complete);
      stream.next(m.controlUid);
      stream.next(m.timedOut);
      stream.next(m.errorCodes);
      stream.next(m.labels);
    }

    ROS_DECLARE_ALLINONE_SERIALIZER
  }; // struct RobustControllerStatus_

} // namespace serialization
} // namespace ros

namespace ros
{
namespace message_operations
{

template<class ContainerAllocator>
struct Printer< ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator> >
{
  template<typename Stream> static void stream(Stream& s, const std::string& indent, const ::baxter_core_msgs::RobustControllerStatus_<ContainerAllocator>& v)
  {
    s << indent << "isEnabled: ";
    Printer<uint8_t>::stream(s, indent + "  ", v.isEnabled);
    s << indent << "complete: ";
    Printer<int32_t>::stream(s, indent + "  ", v.complete);
    s << indent << "controlUid: ";
    Printer<std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other > >::stream(s, indent + "  ", v.controlUid);
    s << indent << "timedOut: ";
    Printer<uint8_t>::stream(s, indent + "  ", v.timedOut);
    s << indent << "errorCodes[]" << std::endl;
    for (size_t i = 0; i < v.errorCodes.size(); ++i)
    {
      s << indent << "  errorCodes[" << i << "]: ";
      Printer<std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other > >::stream(s, indent + "  ", v.errorCodes[i]);
    }
    s << indent << "labels[]" << std::endl;
    for (size_t i = 0; i < v.labels.size(); ++i)
    {
      s << indent << "  labels[" << i << "]: ";
      Printer<std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other > >::stream(s, indent + "  ", v.labels[i]);
    }
  }
};

} // namespace message_operations
} // namespace ros

#endif // BAXTER_CORE_MSGS_MESSAGE_ROBUSTCONTROLLERSTATUS_H

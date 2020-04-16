# distutils: language = c++

from libcpp.string cimport string
from common cimport Message

cdef extern from "pb/people/models/people.pb.h" namespace "pb::people::models":
    cdef enum Person_PhoneType:
        Person_PhoneType_MOBILE,
        Person_PhoneType_HOME,
        Person_PhoneType_WORK

    cdef cppclass Person_PhoneNumber(Message):
        Person_PhoneNumber()
        void set_number(const char* value)
        const string& number()
        void set_type(Person_PhoneType value)
        const Person_PhoneType type()

    cdef cppclass Person(Message):
        Person()
        void set_name(const char* value)
        const string& name() const
        void set_email(const char* value)
        const string& email() const
        void set_id(int value)
        const int id() const
        int phones_size() const
        Person_PhoneNumber* mutable_phones(int index) except +
        Person_PhoneNumber* add_phones()
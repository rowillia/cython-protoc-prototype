# distutils: language = c++

from libcpp.string cimport string
from common cimport Message

cdef extern from "pb/people/models/people.pb.h" namespace "pb::people::models":
    cdef enum Person_PhoneType:
        Person_PhoneType_MOBILE,
        Person_PhoneType_HOME,
        Person_PhoneType_WORK,

    cdef cppclass Person_PhoneNumber(Message):
        Person_PhoneNumber()
        void clear_number()
        const string& number() const
        string* mutable_number()
        void set_number(const char* value)
        void set_number(const char* value, int index)
        void clear_type()
        const Person_PhoneType type() const
        void set_type(Person_PhoneType value)

    cdef cppclass Person(Message):
        Person()
        void clear_name()
        const string& name() const
        string* mutable_name()
        void set_name(const char* value)
        void set_name(const char* value, int index)
        void clear_email()
        const string& email() const
        string* mutable_email()
        void set_email(const char* value)
        void set_email(const char* value, int index)
        void clear_id()
        int id() const
        void set_id(int value)
        void clear_phones()
        const Person_PhoneNumber& phones(int index) except +
        Person_PhoneNumber* mutable_phones(int index) except +
        int phones_size() const
        Person_PhoneNumber* add_phones()
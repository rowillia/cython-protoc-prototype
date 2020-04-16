# distutils: language = c++

from libcpp.string cimport string

from common cimport MessageDifferencer as CppMessageDifferencer
from common cimport Message as CppMessage
from pb.people.models.people_pb_externs cimport Person as CppPerson
from pb.people.models.people_pb_externs cimport Person_PhoneNumber as CppPerson_PhoneNumber
from pb.people.models.people_pb_externs cimport Person_PhoneType as CppPerson_PhoneType
from pb.addressbook.models.addressbook_pb_externs cimport AddressBook as CppAddressBook


cdef class _CythonMessage:
    cdef CppMessage* _internal
    cdef bint _ptr_owner

    def __cinit__(self, _init = True):
        self._ptr_owner = _init

    def __dealloc__(self):
        if self._internal is not NULL and self._ptr_owner is True:
            del self._internal
            self._internal = NULL

    def SerializeToString(self):
        cdef string result = string()
        self._internal.SerializeToString(&result)
        return result

    def ParseFromString(self, data):
        self._internal.ParseFromString(data)

    cdef inline str DebugString(self):
        return self._internal.DebugString().decode('utf-8')

    def __repr__(self):
        return self.DebugString()

    def __str__(self):
        return self.DebugString()

    def __eq__(self, other):
        cdef CppMessageDifferencer differencer
        cdef _CythonMessage _other_message
        if isinstance(other, _CythonMessage):
            _other_message = <_CythonMessage> other
            return differencer.Equals(self._internal[0], _other_message._internal[0])
        return False


cdef class _Person_PhoneNumber(_CythonMessage):
    def __cinit__(self, _init = True):
        if _init:
            self._internal = new CppPerson_PhoneNumber()

    cdef CppPerson_PhoneNumber* _message(self):
        return <CppPerson_PhoneNumber*>self._internal

    @staticmethod
    cdef _Person_PhoneNumber from_cpp(CppPerson_PhoneNumber* other):
        result = _Person_PhoneNumber(_init=False)
        result._internal = other
        return result

    @property
    def number(self):
        return self._message().number().decode('utf-8')

    @number.setter
    def number(self, value):
        self._message().set_number(value.encode('utf-8'))

    @property
    def type(self):
        return self._message().type()

    @type.setter
    def type(self, value):
        self._message().set_type(value)


cdef class Person(_CythonMessage):
    PhoneNumber = _Person_PhoneNumber

    def __cinit__(self, _init = True):
        if _init:
            self._internal = new CppPerson()

    cdef CppPerson* _message(self):
        return <CppPerson*>self._internal

    @staticmethod
    cdef Person from_cpp(CppPerson* other):
        result = Person(_init=False)
        result._internal = other
        return result

    @property
    def name(self):
        return self._message().name().decode('utf-8')

    @name.setter
    def name(self, value):
        self._message().set_name(value.encode('utf-8'))

    @property
    def email(self):
        return self._message().email().decode('utf-8')

    @email.setter
    def email(self, value):
        self._message().set_email(value.encode('utf-8'))

    @property
    def id(self):
        return self._message().id()

    @id.setter
    def id(self, value):
        self._message().set_id(value)

    @property
    def phones(self):
        cdef int i
        cdef CppPerson* _message = self._message()
        for i in range(_message.phones_size()):
            yield _Person_PhoneNumber.from_cpp(_message.mutable_phones(i))


cdef class AddressBook(_CythonMessage):
    def __cinit__(self, _init = True):
        if _init:
            self._internal = new CppAddressBook()

    cdef CppAddressBook* _message(self):
        return <CppAddressBook*>self._internal

    @staticmethod
    cdef from_cpp(CppAddressBook* other):
        result = AddressBook(_init=False)
        result._internal = other
        return result

    @property
    def people(self):
        cdef int i
        cdef CppAddressBook* _message = self._message()
        for i in range(_message.people_size()):
            yield Person.from_cpp(_message.mutable_people(i))


__all__ = ['AddressBook', 'Person'] 
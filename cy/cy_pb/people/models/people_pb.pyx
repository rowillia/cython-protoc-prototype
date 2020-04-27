# distutils: language = c++
# distutils: extra_link_args = -lprotobuf
# distutils: include_dirs = /usr/local/include
# distutils: include_dirs = ../cc
# distutils: library_dirs = /usr/local/lib
# distutils: extra_compile_args= -std=c++11
# distutils: sources = ../cc/pb/people/models/people.pb.cc


from cytobuf.protobuf.message cimport Message
from cy_pb.people.models.people_pb_externs cimport Person as CppPerson
from cy_pb.people.models.people_pb_externs cimport Person_PhoneNumber as CppPerson_PhoneNumber

cdef class _Person_PhoneNumber(Message):
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

cdef class Person(Message):
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


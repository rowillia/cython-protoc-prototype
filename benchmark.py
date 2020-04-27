import argparse
import gc
import json
import linecache
import os
import random
import resource
import string
import sys
from timeit import Timer

from google.protobuf import json_format

from memory_profiler import LineProfiler

from cy_pb.people.models.people_pb import Person as CppPerson
from cy_pb.addressbook.models.addressbook_pb import AddressBook as CyAddressBook

sys.path.append('./py')

from pb.addressbook.models.addressbook_pb2 import AddressBook as CppAddressBook
from pb.people.models.people_pb2 import Person as CppPerson


NS_PER_SEC = 1e9


def random_string(length = 8):
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(length))


def run_timeit(function):
    timer = Timer(function)
    iterations, _ = timer.autorange()
    raw_timings = timer.repeat(3, iterations)
    per_iteration_timings_ns = [dt / iterations for dt in raw_timings]
    best_ns = min(per_iteration_timings_ns)
    return best_ns * NS_PER_SEC


def _measure_memory_inner(constructor, serialized_string, iterations):
    values = []
    # baseline
    for _ in range(iterations):
        value = constructor()
        value.ParseFromString(serialized_string)
        values.append(value)
    # allocated
    values.clear()
    del values
    del value
    # cleared
    gc.collect()
    # collected
    return None


def measure_memory(*args, **kwargs):
    gc.collect()
    result = {}
    profiler = LineProfiler(backend='psutil')
    func = profiler(_measure_memory_inner)
    func(*args, **kwargs)
    for (filename, lines) in profiler.code_map.items():
        all_lines = linecache.getlines(filename)
        last_mem = None
        for (lineno, mem) in lines:
            if mem is None:
                result[all_lines[lineno - 1].strip()[2:]] = last_mem[1]
            last_mem = mem
    return result


def main():
    parser = argparse.ArgumentParser(
        description='Runs a benchmark of Marshmallow.')
    parser.add_argument('--items', type=str, default='1,10,100,1000',
                        help='Comma-seperated list of number of items in the protobuf')
    args = parser.parse_args()
    items = [int(x.strip()) for x in args.items.split(',')]
    print('***** Benchmark Results *****')
    for item_count in items:
        print(f'\n{item_count} Items per proto:')
        baseline = CppAddressBook()
        for _ in range(item_count):
            new_person = baseline.people.add()
            new_person.name = f'{random_string(4)} {random_string(5)}'
            new_person.email = f'{random_string(6)}@gmail.com'
            new_person.id = 1234
            for _ in range(3):
                new_phone = new_person.phones.add()
                new_phone.number = f'+1425{random.randint(1000000,9999999)}'
                new_phone.type = CppPerson.PhoneType.MOBILE
        baseline_proto = baseline.SerializeToString()

        cython_address_book = CyAddressBook()
        cpp_address_book = CppAddressBook()
        cpp_address_book.ParseFromString(baseline_proto)
        cython_address_book.ParseFromString(baseline_proto)
        json_str = json_format.MessageToJson(cpp_address_book)
        py_dict = json.loads(json_str)

        print('\t*** Compute ***')
        json_timeit_result = run_timeit(lambda: json.loads(json_str))
        print(f'\tjson.loads:                \t{json_timeit_result:,.2f}ns')
        cpp_timeit_result = run_timeit(lambda: cpp_address_book.ParseFromString(baseline_proto))
        print(f'\tBaseline ParseFromString:  \t{cpp_timeit_result:,.2f}ns')
        cython_timeit_result = run_timeit(lambda: cython_address_book.ParseFromString(baseline_proto))
        print(f'\tCython   ParseFromString:  \t{cython_timeit_result:,.2f}ns ({cpp_timeit_result / cython_timeit_result:,.2f} X Speedup)')
        json_timeit_result = run_timeit(lambda: json.dumps(py_dict))
        print(f'\tjson.dumps:                \t{json_timeit_result:,.2f}ns')
        cpp_timeit_result = run_timeit(lambda: cpp_address_book.SerializeToString())
        print(f'\tBaseline SerializeToString:\t{cpp_timeit_result:,.2f}ns')
        cython_timeit_result = run_timeit(lambda: cython_address_book.SerializeToString())
        print(f'\tCython   SerializeToString:\t{cython_timeit_result:,.2f}ns ({cpp_timeit_result / cython_timeit_result:,.2f} X Speedup)')
        cpp_timeit_result = run_timeit(lambda: json_format.MessageToJson(cpp_address_book))
        print(f'\tBaseline MessageToJson:    \t{cpp_timeit_result:,.2f}ns')
        cython_timeit_result = run_timeit(lambda: cython_address_book.to_json())
        print(f'\tCython   MessageToJson:    \t{cython_timeit_result:,.2f}ns ({cpp_timeit_result / cython_timeit_result:,.2f} X Speedup)')
        json_timeit_result = run_timeit(lambda: list(py_dict['people']))
        print(f'\tPython Dictionary Iterate:  \t{json_timeit_result:,.2f}ns')
        cpp_timeit_result = run_timeit(lambda: list(cpp_address_book.people))
        print(f'\tBaseline Iterate:          \t{cpp_timeit_result:,.2f}ns')
        cython_timeit_result = run_timeit(lambda: list(cython_address_book.people))
        print(f'\tCython   Iterate:          \t{cython_timeit_result:,.2f}ns ({cpp_timeit_result / cython_timeit_result:,.2f} X Speedup)')
        cpp_person = list(cpp_address_book.people)[0]
        cython_person = list(cython_address_book.people)[0]
        python_person = py_dict['people'][0]
        json_timeit_result = run_timeit(lambda: python_person['name'])
        print(f'\tPython Dictionary Field Access:\t{json_timeit_result:,.2f}ns')
        cpp_timeit_result = run_timeit(lambda: cpp_person.name)
        print(f'\tBaseline Field Access:        \t{cpp_timeit_result:,.2f}ns')
        cython_timeit_result = run_timeit(lambda: cython_person.name)
        print(f'\tCython   Field Access:        \t{cython_timeit_result:,.2f}ns ({cpp_timeit_result / cython_timeit_result:,.2f} X Speedup)')

        cython_memory_result = measure_memory(CyAddressBook, baseline_proto, 5000)
        cpp_memory_result = measure_memory(CppAddressBook, baseline_proto, 5000)

        cython_allocated_memory = cython_memory_result['allocated'] - cython_memory_result['baseline']
        cpp_allocated_memory = cpp_memory_result['allocated'] - cpp_memory_result['baseline']
        percentage_drop = ((cpp_allocated_memory - cython_allocated_memory) / cpp_allocated_memory) * 100
        drop_label = 'Decrease'
        if percentage_drop < 0:
            percentage_drop = abs(percentage_drop)
            drop_label = 'Increase'

        print('\n\t*** Memory ***')
        print(f'\tBaseline Memory for 5k protos:\t{cpp_allocated_memory:,.2f}MB')
        print(f'\tCython   Memory for 5k protos:\t{cython_allocated_memory:,.2f}MB  ({percentage_drop:,.2f}% {drop_label})')
        
if __name__ == "__main__":
    main()
import unittest
import logging
import varfilter


class TestVarfilter(unittest.TestCase):

    def setUp(self):
        print("Preparando el contexto")
        self.source1 = {"teststr1": "Value teststr1",
                        "testint1": 10}
        self.source2 = {"teststr2": "Value teststr2",
                        "testint2": 10,
                        "teststr": "Value str"}

    def test_fVar_default_nonexistent(self):
        print("fVar con valor por defecto no existente")
        t = varfilter.fVar("test1",
                           "default value",
                           None,
                           self.source1)
        self.assertEqual(t, "default value")

    def test_fVar_default_nonexistent_int(self):
        print("fVar con valor por defecto no existente de tipo int")
        t = varfilter.fVar("test1",
                           0,
                           "int",
                           self.source1)
        self.assertEqual(t, 0)

    def test_fVar_default_existent(self):
        print("fVar con valor por defecto")
        t = varfilter.fVar("teststr1",
                           "default value",
                           None,
                           self.source1)
        self.assertEqual(t, "Value teststr1")

    def test_fVar_default_existent_int(self):
        print("fVar con valor por defecto existente de tipo int")
        t = varfilter.fVar("testint1",
                           0,
                           "int",
                           self.source1)
        self.assertEqual(t, 10)

    def test_fVar_default_existent_int_filtererror(self):
        print("fVar con valor por defecto erroneo existente de tipo int")
        t = varfilter.fVar("test1",
                           "error",
                           "int",
                           self.source1)
        self.assertEqual(t, None)

    def test_fVar_existent_severalsources(self):
        print("fVar con valor existente varios sources")
        t = varfilter.fVar("teststr",
                           "default value",
                           None,
                           self.source1,
                           self.source2)
        self.assertEqual(t, "Value str")


if __name__ == '__main__':
    logging.basicConfig(format='%(asctime)s - %(message)s',
                        level=logging.DEBUG)
    unittest.main()

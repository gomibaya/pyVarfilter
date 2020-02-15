import unittest
import logging
from varfilter import filter


class Testfilter(unittest.TestCase):

    def setUp(self):
        print("Preparando el contexto")

    def test_fint_int_ok(self):
        print("fint con entero correcto")
        t = filter.fint(10)
        self.assertEqual(t, 10)

    def test_fint_str_ok(self):
        print("fint con entero string correcto")
        t = filter.fint("10")
        self.assertEqual(t, 10)

    def test_fint_strneg_ok(self):
        print("fint con entero negativo string correcto")
        t = filter.fint("-10")
        self.assertEqual(t, -10)

    def test_fint_strhex_ok(self):
        print("fint con entero hex string correcto")
        t = filter.fint("0xA")
        self.assertEqual(t, 10)

    def test_fint_strbinary_ok(self):
        print("fint con entero binary string correcto")
        t = filter.fint("0b1010")
        self.assertEqual(t, 10)

    def test_fbool_int_ok(self):
        print("fbool con entero correcto")
        t = filter.fbool(10)
        self.assertEqual(t, True)

    def test_fbool_int_ko(self):
        print("fbool con entero false a 0")
        t = filter.fbool(0)
        self.assertEqual(t, False)

    def test_fbool_int_ko_neg(self):
        print("fbool con entero false a 0")
        t = filter.fbool(-0)
        self.assertEqual(t, False)

    def test_fbool_int_ok_neg2(self):
        print("fbool con entero false negativo")
        t = filter.fbool(-5)
        self.assertEqual(t, True)

    def test_fbool_str_true(self):
        print("fbool con string true")
        elements = [' T', 'T ', ' T ', 'T', 't',
                    'True', 'Y', 'Yes', 'SÍ', 'Si']
        for element in elements:
            t = filter.fbool(element)
            self.assertEqual(t, True)

    def test_fbool_str_false(self):
        print("fbool con string false")
        elements = [' F', 'F ', ' F ', 'F', 'f',
                    'False', 'N', 'No']
        for element in elements:
            t = filter.fbool(element)
            self.assertEqual(t, False)


if __name__ == '__main__':
    logging.basicConfig(format='%(asctime)s - %(message)s',
                        level=logging.DEBUG)
    unittest.main()

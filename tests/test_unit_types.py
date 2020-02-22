import unittest
import logging
from varfilter import types


class Testfilter(unittest.TestCase):

    def setUp(self):
        print('Preparando el contexto')
        self.uinfo = types.UserAuthInfo('nombre', 'contraseña')

    def test_UserAuthInfo_ok(self):
        print('UserAuthInfo con valores correctos')
        t = self.uinfo
        self.assertEqual(t.getName(), 'nombre')
        self.assertEqual(t.getPass(), 'contraseña')

    def test_DbInfo__ok(self):
        print('dbInfo con valores correctos')
        t = types.DbInfo(self.uinfo, 'dbname', 'host', 5439)
        self.assertEqual(t.getPort(), 5439)
        self.assertEqual(t.getHost(), 'host')
        self.assertEqual(t.getDbname(), 'dbname')
        self.assertEqual(t.getUinfo(), self.uinfo)


if __name__ == '__main__':
    logging.basicConfig(format='%(asctime)s - %(message)s',
                        level=logging.DEBUG)
    unittest.main()

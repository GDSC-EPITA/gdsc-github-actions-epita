import unittest
from example.simple import say


class TestSimple(unittest.TestCase):
    def test_say(self):
        self.assertEqual(say("Hello"), "Hello")

"""Proves de la Issue #3; totes en simulació, sense permisos root."""
import pathlib
import subprocess
import tempfile
import unittest

SCRIPT = pathlib.Path(__file__).resolve().parents[1] / "scripts" / "exorcism.sh"
HEADER = "IP,Amenaca,Nivell,Port_Infectat\n"


class ExorcismTests(unittest.TestCase):
    def run_csv(self, content):
        with tempfile.TemporaryDirectory() as directory:
            path = pathlib.Path(directory) / "hosts.csv"
            path.write_text(content, encoding="utf-8")
            return subprocess.run(["bash", str(SCRIPT), str(path)], capture_output=True, text=True)

    def test_critical_noncritical_and_multiple_ports(self):
        result = self.run_csv(HEADER + "192.0.2.10,ghost,alt,22\n192.0.2.10,ghost,alt,443\n192.0.2.20,ghost,alt,3389\n192.0.2.30,ghost,baix,8080\n")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.count("SIMULACIÓ:"), 6)
        self.assertIn("OMÈS: 192.0.2.30 TCP/8080", result.stdout)
        self.assertIn("--sport 22", result.stdout)
        self.assertIn("--dport 443", result.stdout)
        self.assertNotIn("--dport 8080", result.stdout)
        self.assertIn("processades: 3; omeses: 1", result.stdout)

    def test_duplicates_and_ipv6(self):
        result = self.run_csv(HEADER + "2001:db8::1,ghost,alt,443\n2001:0db8::1,ghost,alt,443\n2001:db8::1,ghost,alt,22\n")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.count("SIMULACIÓ: ip6tables"), 4)

    def test_invalid_ports_abort_before_any_commands(self):
        for port in ["0", "65536", "-1", "22.0", "ssh", "", "22;id"]:
            with self.subTest(port=port):
                result = self.run_csv(HEADER + "192.0.2.10,ghost,alt,22\n" + f"192.0.2.20,ghost,alt,{port}\n")
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")

    def test_invalid_ip(self):
        result = self.run_csv(HEADER + "invalid,ghost,alt,22\n")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")

    def test_old_schema_rejected(self):
        result = self.run_csv("IP,Amenaca,Nivell\n192.0.2.10,ghost,alt\n")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Capçalera esperada", result.stderr)

    def test_missing_and_extra_fields(self):
        for row in ["192.0.2.10,ghost,alt", "192.0.2.10,ghost,alt,22,extra"]:
            with self.subTest(row=row):
                result = self.run_csv(HEADER + row + "\n")
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")

    def test_noncritical_boundaries_are_valid(self):
        result = self.run_csv(HEADER + "192.0.2.10,ghost,alt,1\n192.0.2.10,ghost,alt,65535\n")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("SIMULACIÓ:", result.stdout)
        self.assertIn("processades: 0; omeses: 2", result.stdout)


if __name__ == "__main__":
    unittest.main()

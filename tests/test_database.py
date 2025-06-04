import sqlite3
import unittest

# Connect database containing progress table which may or may not have data
con = sqlite3.connect("./database/data.db")
curs = con.cursor()
print("Database connected")

class TestDatabase(unittest.TestCase):
    # Tests for basic database operations
    def test_1_insert_db(self):
        insert_result_before = curs.execute("SELECT * FROM progress;").fetchall()
        curs.execute("INSERT INTO progress VALUES(1, 2, 3, 4, 5);")
        insert_result_after = curs.execute("SELECT * FROM progress;").fetchall()
        self.assertEqual(len(insert_result_after), len(insert_result_before) + 1)
    
    def test_2_select_db(self):
        select_result = curs.execute("SELECT id FROM progress WHERE id > 0;").fetchall()
        self.assertEqual(select_result, [(1,)])
    
    def test_3_update_db(self):
        curs.execute("UPDATE progress SET id = -1 WHERE id > 0;")
        update_result = curs.execute("SELECT id FROM progress WHERE id < 0;").fetchall()
        self.assertEqual(update_result, [(-1,)])
    
    def test_4_delete_db(self):
        delete_result_before = curs.execute("SELECT * FROM progress;").fetchall()
        curs.execute("DELETE FROM progress WHERE id < 0;")
        delete_result_after = curs.execute("SELECT * FROM progress;").fetchall()
        self.assertEqual(len(delete_result_after), len(delete_result_before) - 1)
    
    # Tests for progress data elements
    @unittest.skipUnless(curs.execute("SELECT * FROM progress WHERE id = 0;").fetchall(), "Unit test for player progress data")
    def test_5_check_level_number(self):
        result = curs.execute("SELECT level_number FROM progress WHERE id = 0;").fetchall()
        self.assertGreaterEqual(result, [(1,)])
        self.assertLessEqual(result, [(4,)])
    
    @unittest.skipUnless(curs.execute("SELECT * FROM progress WHERE id = 0;").fetchall(), "Unit test for player progress data")
    def test_6_check_max_level_unlocked(self):
        result = curs.execute("SELECT max_level_unlocked FROM progress WHERE id = 0;").fetchall()
        self.assertGreaterEqual(result, [(1,)])
        self.assertLessEqual(result, [(5,)])
    
    @unittest.skipUnless(curs.execute("SELECT * FROM progress WHERE id = 0;").fetchall(), "Unit test for player progress data")
    def test_7_check_attack_damage_bonus(self):
        result = curs.execute("SELECT attack_damage_bonus FROM progress WHERE id = 0;").fetchall()
        self.assertGreaterEqual(result, [(0,)])
    
    @unittest.skipUnless(curs.execute("SELECT * FROM progress WHERE id = 0;").fetchall(), "Unit test for player progress data")
    def test_8_check_defense_armor_bonus(self):
        result = curs.execute("SELECT defense_armor_bonus FROM progress WHERE id = 0;").fetchall()
        self.assertGreaterEqual(result, [(0,)])

if __name__ == "__main__":
    # Print progress table schema and remove unnecessary entries before testing
    schema = curs.execute("PRAGMA table_info(progress);").fetchall()
    print("Schema for progress table: " + str(schema))
    curs.execute("DELETE FROM progress WHERE id != 0;")

    unittest.main()

    curs.execute("DELETE FROM progress WHERE id != 0;")
    curs.close()
    con.close()

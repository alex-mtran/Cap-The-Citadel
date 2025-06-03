import sqlite3
import unittest

class TestDatabase(unittest.TestCase):
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

if __name__ == "__main__":
    con = sqlite3.connect("data.db")
    curs = con.cursor()
    print("Database connected")
    schema = curs.execute("PRAGMA table_info(progress);").fetchall()
    print("Schema for progress table: " + str(schema))
    curs.execute("DELETE FROM progress WHERE id != 0;")

    unittest.main()

    curs.execute("DELETE FROM progress WHERE id != 0;")
    curs.close()
    con.close()

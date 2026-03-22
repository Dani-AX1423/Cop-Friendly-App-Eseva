import tkinter as tk
from tkinter import messagebox
from dbconfig import get_connection

# -------- FUNCTIONS -------- #

def add_complaint():
    try:
        conn = get_connection()
        cursor = conn.cursor()

        query = "INSERT INTO complaints (user_id, complaint_type, description) VALUES (%s, %s, %s)"
        values = (1, type_entry.get(), desc_entry.get())

        cursor.execute(query, values)
        conn.commit()

        messagebox.showinfo("Success", "Complaint Added Successfully")

        type_entry.delete(0, tk.END)
        desc_entry.delete(0, tk.END)

        conn.close()
    except Exception as e:
        messagebox.showerror("Error", str(e))


def view_complaints():
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT complaint_id, complaint_type, status FROM complaints")
    rows = cursor.fetchall()

    output.delete(1.0, tk.END)

    for row in rows:
        output.insert(tk.END, f"ID: {row[0]} | {row[1]} | {row[2]}\n")

    conn.close()


def update_status():
    conn = get_connection()
    cursor = conn.cursor()

    query = "UPDATE complaints SET status='Resolved' WHERE complaint_id=%s"
    cursor.execute(query, (id_entry.get(),))
    conn.commit()

    messagebox.showinfo("Updated", "Status Updated to Resolved")

    conn.close()


# -------- UI DESIGN -------- #

root = tk.Tk()
root.title("Cop Friendly App - Eseva")
root.geometry("400x500")

title = tk.Label(root, text="Cop Friendly App", font=("Arial", 16, "bold"))
title.pack(pady=10)

# Complaint Type
tk.Label(root, text="Complaint Type").pack()
type_entry = tk.Entry(root, width=40)
type_entry.pack(pady=5)

# Description
tk.Label(root, text="Description").pack()
desc_entry = tk.Entry(root, width=40)
desc_entry.pack(pady=5)

# Submit Button
tk.Button(root, text="Submit Complaint", command=add_complaint).pack(pady=10)

# View Button
tk.Button(root, text="View Complaints", command=view_complaints).pack(pady=5)

# Update Section
tk.Label(root, text="Complaint ID to Resolve").pack()
id_entry = tk.Entry(root)
id_entry.pack(pady=5)

tk.Button(root, text="Mark as Resolved", command=update_status).pack(pady=10)

# Output box
output = tk.Text(root, height=10, width=45)
output.pack(pady=10)

root.mainloop()
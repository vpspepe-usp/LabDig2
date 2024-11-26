import streamlit as st
import serial

# Initialize serial communication
ser = serial.Serial('COM3', 115200, timeout=1)

# Streamlit UI
st.title("Control Panel")

# Button
if st.button('Send Data'):
    ser.write(b'Button Pressed\n')

# Switches
switch1 = st.checkbox('Switch 1')
switch2 = st.checkbox('Switch 2')
switch3 = st.checkbox('Switch 3')

# Send switch states
data = f"{int(switch1)},{int(switch2)},{int(switch3)}\n"
ser.write(data.encode())

# Close serial communication
ser.close()
import os
import cv2
from simple_facerec import SimpleFacerec
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from firebase_admin import storage
from firebase_admin import firestore
from firebase_admin import messaging
from datetime import datetime

def mark_attendance_and_notify(name):
    if name == "Unknown":
        return
    today = datetime.now().strftime("%Y-%m-%d")
    attendance_ref = fs.collection("attendance").document(today)
    attendance_data = attendance_ref.get().to_dict()
    if attendance_data:
        if name not in attendance_data:
            attendance_ref.update({name: True})
            # send_notification_to_parents(name)
    else:
        attendance_ref.set({name: True}, merge=True)
        # send_notification_to_parents(name)

# Function to send notification to parents using Firebase Cloud Messaging (FCM)
# def send_notification_to_parents(student_name):
    # Construct the message
    # message = messaging.Message(
    #     notification=messaging.Notification(
    #         title="Attendance Notification",
    #         body=f"{name} has been marked present for today's class."
    #     ),
    #     topic="2022179017"
    # )
    # response = messaging.send(message)
    # print('Notification sent:', response)
    # print(student_name)

cred = credentials.Certificate("./dummy-8a0cb-firebase-adminsdk-cvu6h-cd5cb8f3d7.json")

firebase_admin.initialize_app(cred, {
    "databaseURL" : "https://dummy-8a0cb-default-rtdb.asia-southeast1.firebasedatabase.app/",
    'storageBucket': 'dummy-8a0cb.appspot.com'
})

fs = firestore.client()

ref = db.reference("students/")

bucket = storage.bucket()

# def fetch_images_from_storage(folder_path, local_directory):
#     blobs = bucket.list_blobs(prefix=folder_path)
#     for blob in blobs:
#         if blob.name.endswith('.jpg') or blob.name.endswith('.jpg'):  # Filter for specific image file types
#             destination_file_path = os.path.join(local_directory, os.path.basename(blob.name))
#             blob.download_to_filename(destination_file_path)
#             print(f"Downloaded {blob.name} to {destination_file_path}")

# fetch_images_from_storage('students/', 'images/local_images/')  # Replace 'images/' with your Firebase Storage folder path and 'local_images/' with your local directory path
    
sfr = SimpleFacerec()
sfr.load_encoding_images("images/local_images")

cap = cv2.VideoCapture("./input/input_two.mp4")

while True:
    ret, frame = cap.read()

    # Detect Faces
    face_locations, face_names = sfr.detect_known_faces(frame)
    for name in face_names:
        mark_attendance_and_notify(name)
    for face_loc, name in zip(face_locations, face_names):
        y1, x2, y2, x1 = face_loc[0], face_loc[1], face_loc[2], face_loc[3]
        cv2.putText(frame, name,(x1, y1 - 10), cv2.FONT_HERSHEY_PLAIN, 1, (0, 200, 0), 2)
        cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 200, 0), 4)
        
    cv2.imshow("Frame", frame)

    key = cv2.waitKey(100)
    if key == 27:
        break

cap.release()
cv2.destroyAllWindows()
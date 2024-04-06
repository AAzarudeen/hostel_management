import os
import cv2
from simple_facerec import SimpleFacerec
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
from firebase_admin import storage

cred = credentials.Certificate("./dummy-8a0cb-firebase-adminsdk-cvu6h-cd5cb8f3d7.json")

firebase_admin.initialize_app(cred, {
    "databaseURL" : "https://dummy-8a0cb-default-rtdb.asia-southeast1.firebasedatabase.app/",
    'storageBucket': 'dummy-8a0cb.appspot.com'
})

ref = db.reference("students/")

bucket = storage.bucket()

def fetch_images_from_storage(folder_path, local_directory):
    blobs = bucket.list_blobs(prefix=folder_path)
    for blob in blobs:
        if blob.name.endswith('.jpg') or blob.name.endswith('.jpg'):  # Filter for specific image file types
            destination_file_path = os.path.join(local_directory, os.path.basename(blob.name))
            blob.download_to_filename(destination_file_path)
            print(f"Downloaded {blob.name} to {destination_file_path}")

# Example usage:
fetch_images_from_storage('students/', 'images/local_images/')  # Replace 'images/' with your Firebase Storage folder path and 'local_images/' with your local directory path

sfr = SimpleFacerec()
sfr.load_encoding_images("images/local_images")

cap = cv2.VideoCapture(0)

_out = ["2022179017"]

_in = []

while True:
    ret, frame = cap.read()

    # Detect Faces
    face_locations, face_names = sfr.detect_known_faces(frame)
    for face_loc, name in zip(face_locations, face_names):
        y1, x2, y2, x1 = face_loc[0], face_loc[1], face_loc[2], face_loc[3]
        cv2.putText(frame, name,(x1, y1 - 10), cv2.FONT_HERSHEY_PLAIN, 1, (0, 200, 0), 2)
        cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 200, 0), 4)
        if name in _out:
            y1, x2, y2, x1 = face_loc[0], face_loc[1], face_loc[2], face_loc[3]
            cv2.putText(frame, name,(x1, y1 - 10), cv2.FONT_HERSHEY_PLAIN, 1, (0, 200, 0), 2)
            cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 200, 0), 4)
            if name not in _in:
                # ref = db.reference("/students/"+name)
                # ref.update({"status":"in"})
                _out.remove(name)
        print(_in,"in")
        print(_out,"out")

    cv2.imshow("Frame", frame)

    key = cv2.waitKey(100)
    if key == 27:
        break

cap.release()
cv2.destroyAllWindows()
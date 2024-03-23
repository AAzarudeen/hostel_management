import cv2
from simple_facerec import SimpleFacerec
import firebase_admin
# from firebase_admin import credentials
# from firebase_admin import db

# cred = credentials.Certificate(".\dummy-8a0cb-firebase-adminsdk-cvu6h-cd5cb8f3d7.json")

# firebase_admin.initialize_app(cred, {
#     "databaseURL" : "https://dummy-8a0cb-default-rtdb.asia-southeast1.firebasedatabase.app/"
# })

# ref = db.reference("students/")

sfr = SimpleFacerec()
sfr.load_encoding_images("images/")

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
import cv2
import time

def generate_dataset():
    face_classifier = cv2.CascadeClassifier("haarcascade_frontalface_default.xml")
    
    # Prompt user to input the number of users
    num_users = int(input("Enter the number of users: "))
    
    for user_id in range(1, num_users+1):
        input("Press Enter to start data collection for User {}: ".format(user_id))
        print(f"Collecting data for User {user_id}:")
        
        def face_cropped(img):
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            faces = face_classifier.detectMultiScale(gray, 1.3, 5)

            if len(faces) == 0:
                return None

            for (x, y, w, h) in faces:
                cropped_face = img[y:y+h, x:x+w]
            return cropped_face

        cap = cv2.VideoCapture(0)
        img_id = 0

        while True:
            ret, frame = cap.read()
            if face_cropped(frame) is not None:
                img_id += 1
                face = cv2.resize(face_cropped(frame), (200, 200))
                face = cv2.cvtColor(face, cv2.COLOR_BGR2GRAY)
                file_name_path = f"data/user{user_id}.{img_id}.jpg"
                cv2.imwrite(file_name_path, face)
                print("Saved image:", file_name_path)
                if img_id == 100:
                    break

            # Wait for a short period of time (100 milliseconds)
            time.sleep(0.1)

        cap.release()
        print(f"Data collection for User {user_id} is completed.")

    cv2.destroyAllWindows()
    print("All data collection is completed.")

generate_dataset()
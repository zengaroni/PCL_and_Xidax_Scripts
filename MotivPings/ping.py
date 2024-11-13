from groupy import Client, api
from random import choice
import sys, os

client = Client.from_token('UPtiOMK4v4lMmcYDCpz7p3TnJDCLxeO9DRKIgOBK')
myGroupName = 'MyTestGroup'
myPhotoLib = 'D:/Code/MotivPings/myPhotos/'
myImgHist = 'D:/Code/MotivPings/imgHistory.txt'
historyLength = 100

def fetchImgHist():
    with open(myImgHist, 'rb') as txtFile:
        txtData = txtFile.readlines()

        if len(txtData) > historyLength:
            txtData = txtData[1:]

        print('Img History =', txtData)
        imgHistory = []

        for fileName in txtData:
            fileName = str(fileName)

            try:
                start = fileName.index("'") + 1
                end = fileName.index('.') + 4
                imgHistory.append(fileName[start:end])
            
            except ValueError:
                imgHistory.append(fileName)

        return imgHistory

def logImgHist(filename, imgHistory):
    with open(myImgHist, 'w') as txtFile:
        imgHistory.append(filename)

        for filename in imgHistory:
                txtFile.write(filename)
                txtFile.write('\n')

def selectGroup():
    groups = list(client.groups.list_all())

    for myGroup in groups:
        if myGroup.name == myGroupName:
            break

    if myGroup.name != myGroupName:
        print('ERROR: Incorrect Group Selected')
        sys.exit()
    
    return myGroup

def imgUpload(imgHistory):
    for file in range(len(os.listdir(myPhotoLib))):
        filename = choice(os.listdir(myPhotoLib))
        print(filename)

        if filename not in imgHistory:
            break

    with open(myPhotoLib + filename, 'rb') as f:
        imgUrls = client.images.upload(f)

    myUrl = imgUrls['picture_url']

    return myUrl, filename

def run():
    imgHistory = fetchImgHist()
    myGroup = selectGroup()
    myImgUrl, filename = imgUpload(imgHistory)
    logImgHist(filename, imgHistory)
    myGroup.post(myImgUrl)
    sys.exit()

run()

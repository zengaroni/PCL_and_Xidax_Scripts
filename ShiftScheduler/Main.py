import pickle, os
import WorkerProfiles as wp
import ShiftScheduler as ss
from time import sleep

def LoadWorkers():
    with open("workers.p", "rb") as f:
        myWorkers = pickle.load(f)
    return myWorkers

def MainMenu(myWorkers):
    os.system('cls')
    print('===MainMenu===')
    myInput = input('Would you like to edit workers or schedule?\n')
    
    if (myInput.lower() == 'workers'):
        wp.MainMenu(myWorkers)
    
    elif myInput.lower() == 'schedule':
        ss.InitGroups(myWorkers)

    else:
        print('Invalid Input')
        sleep(1)
        MainMenu(myWorkers)

def Run():
    myWorkers = LoadWorkers()
    MainMenu(myWorkers)
    Run()

Run()
exit()

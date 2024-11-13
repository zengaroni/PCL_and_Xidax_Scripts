import pickle, os
from time import sleep

class worker():
    def __init__(self):
        self.name = ''
        self.key = False
        self.skill = []     # Sales &/or Tech
        self.seniority = 0  # newbie to store manager, 0-5 scale
        self.prefSched = []

    def ProfileEditor(self):
        self.WorkerProfile()
        weInput = input('Edit: key, skill, senior\n')

        if (weInput.lower() == 'key'):
            self.KeyEdit()

        elif (weInput.lower() == 'skill'):
            self.SkillEdit()

        elif (weInput.lower() == 'senior'):
            self.SenEdit()

        else:
            print('input not recognized')
            sleep(1)
            self.ProfileEditor()
        
        return self

    def WorkerProfile(self):
        os.system('cls')
        print('===='+str(self.name)+'====')
        print('Key:', self.key)
        print('Skill:', self.skill)
        print('Seniority:', self.seniority)
        print('Prefered Schedule:', self.prefSched)
        print('----------------------------')

    def KeyEdit(self):
        editInput = input('Please Enter T or F')
        
        if (editInput.lower() == 't'):
            self.key = True

        elif (editInput.lower() == 'f'):
            self.key = False

        else:
            self.ProfileEditor()
        
        return self

    def SkillEdit(self):
        print('===Skills===')
        for skill in self.skill:
                print(skill)
        print('-----------')

        editInput = input('Would you like to Add or Del skill?\n')
    
        if (editInput.lower() == 'add'):
            editInput = input('What is it?')
            self.skill.append(editInput)
            return self

        elif (editInput.lower() == 'del'):
            editInput = input('Which skill?')
            self.skill.remove(editInput)
            return self

        else:
            print('==Invalid Input==')
            sleep(1)
            self.SkillEdit()

    def SenEdit(self):
        weInput = input('Change level 1-5')
        try:
            myInt = int(weInput)
            print(myInt)
            
            if (myInt > 5):
                myInt = 5
            
            elif (myInt < 1):
                myInt = 1
            
            self.seniority = myInt
            return self

        except (ValueError):
            print('input not recognized')
            sleep(1)
            self.ProfileEditor()

def CreateWorkers():
    zen = worker()
    zen.name = 'Zen'
    zen.key = True
    zen.skill = ['Tech']
    zen.seniority = 4
    zen.prefSched = {
    'Mon':('on',4), # o-open, c-close, n-off, b-burn
    'Tue':('o',1),
    'Wed':('o',1),
    'Thu':('o',3),
    'Fri':('o',3),
    'Sat':('on',5)}
    zen.prioTotal = 0

    brandon = worker()
    brandon.name = 'Brandon'
    brandon.key = True
    brandon.skill = ['Tech','Sales']
    brandon.seniority = 5
    brandon.prefSched = {
    'Mon':('oc',1),
    'Tue':('o',4),
    'Wed':('oc',1),
    'Thu':('n',5),
    'Fri':('o',4),
    'Sat':('o',5)}
    brandon.prioTotal = 0

    baron = worker()
    baron.name = 'Baron'
    baron.key = True
    baron.skill = ['Sales']
    baron.seniority = 3
    baron.prefSched = []
    baron.prioTotal = 0

    julian = worker()
    julian.name = 'Julian'
    julian.key = False
    julian.skill = ['Tech']
    julian.seniority = 2
    julian.prefSched = []
    julian.prioTotal = 0

    trevor = worker()
    trevor.name = 'Trevor'
    trevor.key = False
    trevor.skill = ['Tech']
    trevor.seniority = 1
    trevor.prefSched = {
    'Mon':('cn',3),
    'Tue':('o',2),
    'Wed':('oc',1),
    'Thu':('oc',2),
    'Fri':('o',4),
    'Sat':('on',5)}
    trevor.prioTotal = 0

    myWorkers = [zen, brandon, baron, trevor, julian]

    for myWorker in myWorkers:
        for day in myWorker.prefSched:
            dayInfo = myWorker.prefSched[day]
            myWorker.prioTotal += dayInfo[1]
        print(myWorker.name, myWorker.prioTotal)
    
    input()

    pickle.dump(myWorkers, open("workers.p", "wb"))
    return myWorkers

def MainMenu(myWorkers):
    os.system('cls')
    print('====User Profiles====')
    for worker in myWorkers:
        print(worker.name)
    print('---------------------')
    print('Exit (type exit), Reset (type ResetAllClasses)')
    myInput = input("Who would you like to edit?:  ")

    if (myInput.lower() == 'exit'):
        return myWorkers
    
    elif (myInput.lower() == 'resetallclasses'):
        os.system('cls')
        myWorkers = CreateWorkers()
        print('Workers set to defaults')
        sleep(1)
        MainMenu(myWorkers)

    else:
        for worker in myWorkers:
            if (worker.name.lower() == myInput.lower()):
                worker.ProfileEditor()
                myWorkers[myWorkers.index(worker)] = worker
                pickle.dump(myWorkers, open("workers.p", "wb"))
                MainMenu(myWorkers)
        
        print('No Worker under that name.')
        sleep(1)
        MainMenu(myWorkers)

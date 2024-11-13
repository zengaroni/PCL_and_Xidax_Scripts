from time import sleep
from random import shuffle

scheduleDict = {
    'Mon':[(0,'n'),(0,'n'),(0,'n'),(0,'n'),(0,'n'),(0,'n')],
    'Tue':[(0,'n'),(0,'n'),(0,'n'),(0,'n'),(0,'n'),(0,'n')],
    'Wen':[(0,'n'),(0,'n'),(0,'n'),(0,'n'),(0,'n'),(0,'n')],
    'Thu':[(0,'n'),(0,'n'),(0,'n'),(0,'n'),(0,'n'),(0,'n')],
    'Fri':[(0,'n'),(0,'n'),(0,'n'),(0,'n'),(0,'n'),(0,'n')],
    'Sat':[(0,'n'),(0,'n'),(0,'n'),(0,'n'),(0,'n'),(0,'n')]
}

def InitGroups(myWorkers):
    keyHolders = []
    skillDict = {}
    for myWorker in myWorkers:
        if (myWorker.key == True):
            keyHolders.append(myWorker)
        
        for skill in myWorker.skill:
            try:
                skillDict[skill.lower()].append(myWorker) 
            except KeyError:
                skillDict[skill.lower()] = [myWorker]

    ScheduleWeek(myWorkers, keyHolders, skillDict)
              
def ScheduleWeek(myWorkers, keyHolders, skillDict):
    for day in scheduleDict:
        keyHolders = shuffle(keyHolders)
        for keyHolder in keyHolders:
            keyHolder.prefSched[day]
        

    



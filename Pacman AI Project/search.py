# search.py
# ---------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

import util

class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self):
        """
        Returns the start state for the search problem.
        """
        util.raiseNotDefined()

    def isGoalState(self, state):
        """
          state: Search state

        Returns True if and only if the state is a valid goal state.
        """
        util.raiseNotDefined()

    def getSuccessors(self, state):
        """
          state: Search state

        For a given state, this should return a list of triples, (successor,
        action, stepCost), where 'successor' is a successor to the current
        state, 'action' is the action required to get there, and 'stepCost' is
        the incremental cost of expanding to that successor.
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.
        The sequence must be composed of legal moves.
        """
        util.raiseNotDefined()


def tinyMazeSearch(problem):
    """
    Returns a sequence of moves that solves tinyMaze.  For any other maze, the
    sequence of moves will be incorrect, so only use this for tinyMaze.
    """
    from game import Directions
    s = Directions.SOUTH
    w = Directions.WEST
    return  [s, s, w, s, w, w, s, w]

def depthFirstSearch(problem: SearchProblem):
    """
    Search the deepest nodes in the search tree first.

    Your search algorithm needs to return a list of actions that reaches the
    goal. Make sure to implement a graph search algorithm.

    To get started, you might want to try some of these simple commands to
    understand the search problem that is being passed in:

    print("Start:", problem.getStartState())
    print("Is the start a goal?", problem.isGoalState(problem.getStartState()))
    print("Start's successors:", problem.getSuccessors(problem.getStartState()))
    """
    "*** YOUR CODE HERE ***"
    stack = util.Stack()
    stack.push((problem.getStartState(), [])) # push starting node/state and actions
    visited = set() # keep track of nodes/states which were visited
    while not stack.isEmpty():
        state = stack.pop()
        current_state = state[0]
        actions = state[1]
        visited.add(current_state)

        if problem.isGoalState(current_state):
            return actions
        
        successors = problem.getSuccessors(current_state)
        for i, j, cost in successors:
            next_state = i
            if next_state not in visited:
                actions_list = actions + [j]
                stack.push((next_state, actions_list))
    
    return actions_list
    util.raiseNotDefined()

def breadthFirstSearch(problem: SearchProblem):
    """Search the shallowest nodes in the search tree first."""
    "*** YOUR CODE HERE ***"
    queue = util.Queue()
    queue.push((problem.getStartState(), []))  #push starting node/state and actions
    visited = set()

    while not queue.isEmpty():
        state = queue.pop()
        current_state = state[0]
        actions = state[1]
        visited.add(current_state) 

        if problem.isGoalState(current_state):
            return actions
        
        successors = problem.getSuccessors(current_state)
        for i,j,cost in successors:
            next_state = i
            if next_state not in visited:
                actions_list = actions + [j]
                queue.push((next_state, actions_list))
                visited.add(next_state)

    return actions_list
    util.raiseNotDefined()

def uniformCostSearch(problem: SearchProblem):
    """Search the node of least total cost first."""
    "*** YOUR CODE HERE ***"
    priority_queue = util.PriorityQueue()
    actions_cost = {}
    priority_queue.push(problem.getStartState(), 0)
    actions_cost[problem.getStartState()] = ([], 0) #storing actions taken and respective cost as values for the node/state as the key
    visited = set()
    
    while not priority_queue.isEmpty():
        #state = priority_queue.pop()
        #print(state)
        current_state = priority_queue.pop()
        #print(current_state)
        actions, cost = actions_cost[current_state]
        #print(actions)
        #print(cost)
        visited.add(current_state)

        if problem.isGoalState(current_state):
            return actions
        
        successors = problem.getSuccessors(current_state)
        for i,j,step_cost in successors:
            next_state = i
            if next_state not in visited:
                actions_list = actions + [j]
                total_cost = cost + step_cost
                
                # check if already visited and have lower priority
                if next_state not in actions_cost or total_cost < actions_cost[next_state][1]:
                    actions_cost[next_state] = (actions_list, total_cost)
                    #update node or else push to queue
                    priority_queue.update(next_state, total_cost)
                    #priority_queue.push(next_state, total_cost)

    return actions_list
    util.raiseNotDefined()

def nullHeuristic(state, problem=None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def aStarSearch(problem: SearchProblem, heuristic=nullHeuristic):
    """Search the node that has the lowest combined cost and heuristic first."""
    "*** YOUR CODE HERE ***"
    priority_queue = util.PriorityQueue()
    actions_cost = {}
    priority_queue.push(problem.getStartState(), 0)
    actions_cost[problem.getStartState()] = ([], 0)
    visited = set()

    while not priority_queue.isEmpty():
        current_state = priority_queue.pop()
        actions, cost = actions_cost[current_state]
        visited.add(current_state)

        if problem.isGoalState(current_state):
            return actions

        successors = problem.getSuccessors(current_state)
        for i, j, step_cost in successors:
            next_state = i
            if next_state not in visited:
                actions_list = actions + [j]
                total_cost = cost + step_cost
                total_priority = total_cost + heuristic(next_state, problem)
                if next_state not in actions_cost or total_cost < actions_cost[next_state][1]:
                    actions_cost[next_state] = (actions_list, total_cost)
                    priority_queue.update(next_state, total_priority)

    return None
    util.raiseNotDefined()


# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch

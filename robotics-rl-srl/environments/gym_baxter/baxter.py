import math
import os

import numpy as np
import pybullet as p
import pybullet_data

from time import sleep

class Baxter:
    """
    Represents the Kuka arm in the PyBullet simulator
    :param urdf_root_path: (str) Path to pybullet urdf files
    :param timestep: (float)
    :param use_inverse_kinematics: (bool) enable dx,dy,dz control rather than direct joint control
    :param small_constraints: (bool) reduce the searchable space
    """

    def __init__(self, timestep=0.01, use_inverse_kinematics=True,
                 small_constraints=True):
#        self.urdf_root_path = urdf_root_path
        self.timestep = timestep
        self.max_velocity = .35
        self.max_force = 200.
        self.fingerA_force = 2
        self.fingerB_force = 2.5
        self.finger_tip_force = 2
        self.use_inverse_kinematics = use_inverse_kinematics
        self.use_simulation = True
        self.use_null_space = False
        self.use_orientation = True

#        self.kuka_end_effector_index = 6
        self.endEffectorId = 8  # Finger A
        self.initialSimSteps = 100
        self.includeFixed=False
        # lower limits for null space
        self.ll = [-.967, -2, -2.96, 0.19, -2.96, -2.09, -3.05]
        # upper limits for null space
        self.ul = [.967, 2, 2.96, 2.29, 2.96, 2.09, 3.05]
        # joint ranges for null space
        self.jr = [5.8, 4, 5.8, 4, 5.8, 4, 6]
        # restposes for null space
        self.rp = [0, 0, 0, 0.5 * math.pi, 0, -math.pi * 0.5 * 0.66, 0]
        # joint damping coefficents
        self.jd = [0.00001, 0.00001, 0.00001, 0.00001, 0.00001, 0.00001, 0.00001, 0.00001, 0.00001, 0.00001, 0.00001,
                   0.00001, 0.00001, 0.00001]

        self.kuka_uid = None

        # affects the clipping of the end_effector_pos
        if small_constraints:
            self.min_x, self.max_x = 0.50, 0.65
            self.min_y, self.max_y = -0.17, 0.22
            self.min_z, self.max_z = 0, 0.5
        else:
            self.min_x, self.max_x = 0.35, 0.65
            self.min_y, self.max_y = -0.30, 0.30
            self.min_z, self.max_z = 0, 0.5
        self.reset()

        
        lowerLimits, upperLimits, jointRanges, restPoses = [], [], [], []
(bodyId, endEffectorId, targetPosition, lowerLimits, upperLimits, jointRanges, restPoses, 
               useNullSpace=False, maxIter=10, threshold=1e-4

    def reset(self):
        """
        Reset the environment
        """
        p.resetSimulation()

        p.loadURDF("plane.urdf", [0, 0, -1], useFixedBase=True)

        sleep(0.1)
        p.configureDebugVisualizer(p.COV_ENABLE_RENDERING,0)
        # Load Baxter
        objects = p.loadSDF("baxter_common/baxter_discription/urdf/toms_baxter.urdf", useFixedBase=True)

        self.baxter_uid = objects[0]
        p.resetBasePositionAndOrientation(baxterId, [0.5, -0.8, 0.0], [0., 0., -1., -1.])

        p.configureDebugVisuaizer(p.COV_ENABLE_RENDERING,1)

        endEffectorId = 48 # (left gripper finger)

        p.setGravity(0., 0., -10.)

        for _ in range(initialSimSteps):
            p.stepSimulation()

#        self.num_joints = p.getNumJoints(self.kuka_uid)
#        for jointIndex in range(self.num_joints):
#            p.resetJointState(self.kuka_uid, jointIndex, self.joint_positions[jointIndex])
#            p.setJointMotorControl2(self.kuka_uid, jointIndex, p.POSITION_CONTROL,
#                                    targetPosition=self.joint_positions[jointIndex], force=self.max_force)

#        self.end_effector_pos = np.array([0.537, 0.0, 0.5])
#        self.end_effector_angle = 0
#
#        self.motor_names = []
#        self.motor_indices = []
        return self.baxter_uid, self.endEffectorId


    def getJointRanges(self):

        lowerLimits, upperLimits, jointRanges, restPoses = [], [], [], []
        self.num_joints = p.getNumJoints(bodyId)


        for i in range(self.num_joints):
            jointInfo = p.getJointInfo(self.baxter_uid, i)

            if includeFixed or jointInfo[3] > -1:

                ll, ul = jointInfo[8:10]
                jr = ul - ll

                # For simplicity, assume resting state == initial state
                rp = p.getJointState(self.baxter_uid, i)[0]

                lowerLimits.append(-2)
                upperLimits.append(2)
                jointRanges.append(2)
                restPoses.append(rp)

#        for i in range(self.num_joints):
#            joint_info = p.getJointInfo(self.kuka_uid, i)
#            q_index = joint_info[3]
#            if q_index > -1:
#                self.motor_names.append(str(joint_info[1]))
#                self.motor_indices.append(i)
    return loweverLimits, upperLimits, jointRanges, restPoses


    def getActionDimension(self):
        """
        Returns the action space dimensions
        :return: (int)
        """
        if self.use_inverse_kinematics:
            return len(self.motor_indices)
        return 6  # position x,y,z and roll/pitch/yaw euler angles of end effector

    def getObservationDimension(self):
        """
        Returns the observation space dimensions
        :return: (int)
        """
        return len(self.getObservation())

    def getObservation(self):
        """
        Returns the position and angle of the effector
        :return: ([float])
        """
        observation = []
        state = p.getLinkState(self.baxter_uid, self.endEffectorId)
        pos = state[0]
        orn = state[1]
        euler = p.getEulerFromQuaternion(orn)

        observation.extend(list(pos))
        observation.extend(list(euler))

        return observation


def accurateIK(self):
    """
    Parameters
    ----------
    bodyId : int
    endEffectorId : int
    targetPosition : [float, float, float]
    lowerLimits : [float] 
    upperLimits : [float] 
    jointRanges : [float] 
    restPoses : [float]
    useNullSpace : bool
    maxIter : int
    threshold : float

    Returns
    -------
    jointPoses : [float] * numDofs
    """
    closeEnough = False
    iter = 0
    dist2 = 1e30

    numJoints = p.getNumJoints(baxterId)

    while (not closeEnough and iter<maxIter):
        if useNullSpace:
            jointPoses = p.calculateInverseKinematics(bodyId, endEffectorId, targetPosition,
                lowerLimits=lowerLimits, upperLimits=upperLimits, jointRanges=jointRanges, 
                restPoses=restPoses)
        else:
            jointPoses = p.calculateInverseKinematics(bodyId, endEffectorId, targetPosition)
    
        for i in range(numJoints):
            jointInfo = p.getJointInfo(bodyId, i)F
            qIndex = jointInfo[3]
            if qIndex > -1:
                p.resetJointState(bodyId,i,jointPoses[qIndex-7])
#        ls = p.getLinkState(bodyId,endEffectorId)    
        newPos = ls[4]
        diff = [targetPosition[0]-newPos[0],targetPosition[1]-newPos[1],targetPosition[2]-newPos[2]]
        dist2 = np.sqrt((diff[0]*diff[0] + diff[1]*diff[1] + diff[2]*diff[2]))
        print("dist2=",dist2)
        closeEnough = (dist2 < threshold)
        iter=iter+1
    print("iter=",iter)
    return jointPoses

def setMotors(bodyId, jointPoses):
    """
    Parameters
    ----------
    bodyId : int
    jointPoses : [float] * numDofs
    """
    numJoints = p.getNumJoints(bodyId)

    for i in range(numJoints):
        jointInfo = p.getJointInfo(bodyId, i)
        #print(jointInfo)
        qIndex = jointInfo[3]
        if qIndex > -1:
            p.setJointMotorControl2(bodyIndex=bodyId, jointIndex=i, controlMode=p.POSITION_CONTROL,
                                    targetPosition=jointPoses[qIndex-7])


    def applyAction(self, motor_commands):
        """
        Applies the action to the effector arm
        :param motor_commands: (list int) dx,dy,dz,da and finger angle
            if inverse kinematics is enabled, otherwise 9 joint angles
        """
guiClient = p.connect(p.GUI)
    p.resetDebugVisualizerCamera(2., 180, 0., [0.52, 0.2, np.pi/4.])


    targetPosXId = p.addUserDebugParameter("targetPosX",-1,1,0.2)
    targetPosYId = p.addUserDebugParameter("targetPosY",-1,1,0)
    targetPosZId = p.addUserDebugParameter("targetPosZ",-1,1,-0.1)
    nullSpaceId = p.addUserDebugParameter("nullSpace",0,1,1)

    baxterId, endEffectorId = setUpWorld()

    lowerLimits, upperLimits, jointRanges, restPoses = getJointRanges(baxterId, includeFixed=False)

    
    #targetPosition = [0.2, 0.8, -0.1]
    #targetPosition = [0.8, 0.2, -0.1]
    targetPosition = [0.2, 0.0, -0.1]
    
    p.addUserDebugText("TARGET", targetPosition, textColorRGB=[1,0,0], textSize=1.5)


    maxIters = 100000

    sleep(1.)

    p.getCameraImage(320,200, renderer=p.ER_BULLET_HARDWARE_OPENGL )
    for _ in range(maxIters):
      p.stepSimulation()
      targetPosX = p.readUserDebugParameter(targetPosXId)
      targetPosY = p.readUserDebugParameter(targetPosYId)
      targetPosZ = p.readUserDebugParameter(targetPosZId)
      nullSpace = p.readUserDebugParameter(nullSpaceId)

      targetPosition=[targetPosX,targetPosY,targetPosZ]
      
      useNullSpace = nullSpace>0.5
      print("useNullSpace=",useNullSpace)
      jointPoses = accurateIK(baxterId, endEffectorId, targetPosition, lowerLimits, upperLimits, jointRanges, restPoses, useNullSpace=useNullSpace)
      setMotors(baxterId, jointPoses)

      #sleep(0.1)

        if self.use_inverse_kinematics:

            dx = motor_commands[0]
            dy = motor_commands[1]
            dz = motor_commands[2]
            da = motor_commands[3]
            finger_angle = motor_commands[4]

            # Constrain effector position
            self.end_effector_pos[0] += dx
            self.end_effector_pos[0] = np.clip(self.end_effector_pos[0], self.min_x, self.max_x)
            self.end_effector_pos[1] += dy
            self.end_effector_pos[1] = np.clip(self.end_effector_pos[1], self.min_y, self.max_y)
            self.end_effector_pos[2] += dz
            self.end_effector_pos[2] = np.clip(self.end_effector_pos[2], self.min_z, self.max_z)
            self.end_effector_angle += da

            pos = self.end_effector_pos
            # Fixed orientation
            orn = p.getQuaternionFromEuler([0, -math.pi, 0])  # -math.pi,yaw])
            if self.use_null_space:
                if self.use_orientation:
                    joint_poses = p.calculateInverseKinematics(self.kuka_uid, self.kuka_end_effector_index, pos, orn,
                                                               self.ll, self.ul, self.jr, self.rp)
                else:
                    joint_poses = p.calculateInverseKinematics(self.kuka_uid, self.kuka_end_effector_index, pos,
                                                               lowerLimits=self.ll, upperLimits=self.ul,
                                                               jointRanges=self.jr, restPoses=self.rp)
            else:
                if self.use_orientation:
                    joint_poses = p.calculateInverseKinematics(self.kuka_uid, self.kuka_end_effector_index, pos, orn,
                                                               jointDamping=self.jd)
                else:
                    joint_poses = p.calculateInverseKinematics(self.kuka_uid, self.kuka_end_effector_index, pos)

        else:
            joint_poses = motor_commands
            self.end_effector_angle += motor_commands[7]
            finger_angle = motor_commands[8]

        if self.use_simulation:
            # using dynamic control
            for i in range(self.kuka_end_effector_index + 1):
                p.setJointMotorControl2(bodyUniqueId=self.kuka_uid, jointIndex=i, controlMode=p.POSITION_CONTROL,
                                        targetPosition=joint_poses[i], targetVelocity=0, force=self.max_force,
                                        maxVelocity=self.max_velocity, positionGain=0.3, velocityGain=1)
        else:
            # reset the joint state (ignoring all dynamics, not recommended to use during simulation)
            for i in range(self.kuka_end_effector_index + 1):
                p.resetJointState(self.kuka_uid, i, joint_poses[i])

        # Effectors grabbers angle
        p.setJointMotorControl2(self.kuka_uid, 7, p.POSITION_CONTROL, targetPosition=self.end_effector_angle,
                                force=self.max_force)
        p.setJointMotorControl2(self.kuka_uid, 8, p.POSITION_CONTROL, targetPosition=-finger_angle,
                                force=self.fingerA_force)
        p.setJointMotorControl2(self.kuka_uid, 11, p.POSITION_CONTROL, targetPosition=finger_angle,
                                force=self.fingerB_force)

        p.setJointMotorControl2(self.kuka_uid, 10, p.POSITION_CONTROL, targetPosition=0,
                                force=self.finger_tip_force)
        p.setJointMotorControl2(self.kuka_uid, 13, p.POSITION_CONTROL, targetPosition=0,
                                force=self.finger_tip_force)

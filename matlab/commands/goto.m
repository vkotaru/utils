function goto(foldername)

if contains('qrotor_matlab', foldername)
    cd /home/kotaru/workspace/catkin_ws/qrotor/src/qrotor_offboard/qrotor_gnd_control/matlab/
    
elseif contains( 'estimation', foldername)
   cd /home/kotaru/workspace/git/HybridRobotics/estimation-on-manifolds/ 
   
elseif contains('bags', foldername)
    cd /home/kotaru/workspace/catkin_ws/qrotor/bags/
    
elseif contains('PPQL',foldername)
    cd /home/kotaru/workspace/git/HybridRobotics/PPQL/
    
elseif contains('research',foldername)
    cd /home/kotaru/workspace/research/
    
elseif contains('matlab',foldername)
    cd /home/kotaru/Documents/MATLAB/
end

end
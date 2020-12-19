//annotation in Chinese is unavailable on my modelsim, using English instead
module inductionlamp(clk,stimulate,light1,light2,light3,light4);
input [3:0]stimulate;
input clk;//input clock period should be 0.1s. if it's not, an external frequency divider is needed
output light1,light2,light3,light4;
reg light1,light2,light3,light4;//output signal which is  the light of each floors
reg [60:0]lghttime1,lghttime2,lghttime3,lghttime4;
//timers for light time. only when stimulate exists less than 6s
wire [3:0]stimulate;//input signal stimulate
reg energysv[3:0];//bool for whether to turn to energy saving mode
reg [70:0]timer1,timer2,timer3,timer4;
//timers for stimulate
reg flag1,flag2,flag3,flag4;//flag for counting 3s then turn off the light
reg [5:0]counter1,counter2,counter3,counter4;
//counter for 0.5s then turn off the light, used in energy saving procedure
reg [30:0]counter3s1,counter3s2,counter3s3,counter3s4;
//When stimulate lasts for longer than 6s, turn off the light until 3sec after the disappearance of the stimulate


initial begin//initial all of the registers to 0
  flag1=0;
  flag2=0;
  flag3=0;
  flag4=0;
  timer1=0;
  timer2=0;
  timer3=0;
  timer4=0;
  counter1=0;
  counter2=0;
  counter3=0;
  counter4=0;
  counter3s1=0;
  counter3s2=0;
  counter3s3=0;
  counter3s4=0;
  light1=0;
  light2=0;
  light3=0;
  light4=0;
  lghttime1=0;
  lghttime2=0;
  lghttime3=0;
  lghttime4=0;  
  energysv[0]=0;
  energysv[1]=0;
  energysv[2]=0;
  energysv[3]=0;
end

always@(posedge clk)
begin
      if(stimulate==4'b1000||timer1>=3)
      //to enter this if block, when the  stimulate  appears for less than 3sec, stimulate==4'b1000
      //when the stimulate lasts for more than 0.3sec, whether or not it disappears, timer1>=3, start if
      begin
                 if(timer1<=68)
                 begin
                 timer1<=(timer1+1);//begin timing when the stimulate appears
                 end

                 if(timer1<3&&stimulate!=4'b1000)
                 begin
                   timer1<=0;//if the stimulate lasts for less than 0.3sec, regard it as a disruption, clear timer1
                 end
                 
                 if(timer1>=3&&timer1<=63)
                 //if the stimulate lasts for more than 0.3sec,turn on the light for 6s if it didn't enter energy saving mode
                 begin
                   if(lghttime1<56)
                   begin
                   light1<=1;//turn on the light of 1st floor
                   lghttime1=lghttime1+1;//count for light time
                   end
                   if(energysv[0]==1||(lghttime1==56&&stimulate!=4'b1000))
                     //whether or not energy saving mode is on, turn on the light in the last 0.5sec of 6s
                   begin
                     counter1<=1+counter1;
                       if (counter1>=5)//in energy saving mode, light up floor 1 for 0.5s then turn off
                       begin
                            light1<=0;
                            counter1<=0;
                            timer1<=0;
                            lghttime1<=0;
                            energysv[0]<=0;
                            counter3s1<=0;
                       end//if the time is over, clear all relative registers
                   end
                 end
                
                   if(timer1>63)
                   //if stimulate lasts for more than 6sec, consider multiple situations below:
 
                   begin
                   if(energysv[0]==1)
                   begin
                     counter1<=counter1+1;
                       if (counter1>=5)
                       //in energy saving mode even the stimulate still exists, light up floor 1 for 0.5s then turn off
                       begin
                            light1<=0;
                            counter1<=0;
                            timer1<=0;
                            lghttime1<=0;
                            energysv[0]<=0;
                            counter3s1<=0;
                       end//if the time is over, clear all relative registers
                   end
                   
                     if(flag1==0)
                     begin
                       light1<=1;
                     end
                       if(flag1==1)
                   //if stimulate lasts for more than 6sec and didn't enter energy saving mode, let flag=1
                   //then turn off the light until 3sec after the disappearance of the stimulate
                       begin
                         if(counter3s1<=30)
                         begin
                           counter3s1<=counter3s1+1;//count for 3sec
                         end
                         if(energysv[0]==1)
                         //during the conuting of 3s, if it enters energy saving mode, still turn off the light
                         //of this floor after 0.5sec and clear the register of counter
                         begin
                           counter3s1<=0;
                         end
                         if(counter3s1>30)
                           //if 3sec passed and didn't enter energy saving mode, then turn off the light
                         begin
                           flag1<=0;
                           counter3s1<=0;
                           timer1<=0;
                           lghttime1<=0;
                           light1<=0;
                           energysv[0]<=0;
                         end//if the time is over, clear all relevant registers
                       end
                   end
      end
      
      if(stimulate==4'b0100||timer2>=3)
        //to enter this if block, when the  stimulate  appears for less than 3sec, stimulate==4'b1000
        //when the stimulate lasts for more than 0.3sec, whether or not it disappears, timer1>=3, start if
      begin
                 if(timer2<=68)
                 begin
                 timer2<=(timer2+1);//begin timing when the stimulate appears
                 end

                 if(timer2<3&&stimulate!=4'b0100)
                 begin
                   timer2<=0;
                   //if the stimulate lasts for less than 0.3sec, regard it as a disruption, clear timer2
                 end
                 
                 if(timer2>=3&&timer2<=63)
                   //if the stimulate lasts for more than 0.3sec,turn on the light for 6s if it didn't enter energy saving mode
                 begin
                   if(lghttime2<56)
                   begin
                   light2<=1;//turn on the light of 2nd floor
                   lghttime2=lghttime2+1;//count for light time
                   end
                   if(energysv[1]==1||(lghttime2==56&&stimulate!=4'b0100))
                     //whether or not energy saving mode is on, turn on the light in the last 0.5sec of 6s
                   begin
                     counter2<=1+counter2;
                       if (counter2>=5)//in energy saving mode, light up floor 1 for 0.5s then turn off
                       begin
                            light2<=0;
                            counter2<=0;
                            timer2<=0;
                            lghttime2<=0;
                            energysv[1]<=0;
                            counter3s2<=0;
                       end//if the time is over, clear all relative registers
                   end
                 end
                
                   if(timer2>63)//if stimulate lasts for more than 6sec, consider multiple situations below:
                   begin
                   if(energysv[1]==1)
                   begin
                     counter2<=counter2+1;
                       if (counter2>=5)//in energy saving, light up floor 2 for 0.5s
                       begin
                            light2<=0;
                            counter2<=0;
                            timer2<=0;
                            lghttime2<=0;
                            energysv[1]<=0;
                            counter3s2<=0;
                       end//if the time is over, clear all relative registers
                   end
                   
                     if(flag2==0)
                     begin
                       light2<=1;
                     end
                       if(flag2==1)
                         //if stimulate lasts for more than 6sec and didn't enter energy saving mode, let flag=1
                         //then turn off the light until 3sec after the disappearance of the stimulate
                       begin
                         if(counter3s2<=30)
                         begin
                           counter3s2<=counter3s2+1;
                         end
                         if(energysv[1]==1)
                         begin
                           counter3s2<=0;
                         end
                         if(counter3s2>30)
                           //if 3sec passed and didn't enter energy saving mode, then turn off the light
                         begin
                           flag2<=0;
                           counter3s2<=0;
                           timer2<=0;
                           lghttime2<=0;
                           light2<=0;
                           energysv[1]<=0;
                         end//turn the light and clear all of the relevant registers
                       end
                   end
      end
      
      if(stimulate==4'b0010||timer3>=3)
        //to enter this if block, when the  stimulate  appears for less than 3sec, stimulate==4'b1000
        //when the stimulate lasts for more than 0.3sec, whether or not it disappears, timer1>=3, start 
      begin
                 if(timer3<=68)
                 begin
                 timer3<=(timer3+1);//begin timing when the stimulate appears
                 end

                 if(timer3<3&&stimulate!=4'b0010)
                 begin
                   timer3<=0;
                   //if the stimulate lasts for less than 0.3sec, regard it as a disruption, clear timer3
                 end
                 
                 if(timer3>=3&&timer3<=63)
                   //if the stimulate lasts for more than 0.3sec,turn on the light for 6s if it didn't enter energy saving mode
                 begin
                   if(lghttime3<56)
                   begin
                   light3<=1;//turn on the light of 3rd floor
                   lghttime3=lghttime3+1;//count for light time
                   end
                   if(energysv[2]==1||(lghttime3==56&&stimulate!=4'b0010))
                     //whether or not energy saving mode is on, turn on the light in the last 0.5sec of 6s
                   begin
                     counter3<=1+counter3;
                       if (counter3>=5)//in energy saving mode, light up floor 3 for 0.5s then turn off
                       begin
                            light3<=0;
                            counter3<=0;
                            timer3<=0;
                            lghttime3<=0;
                            energysv[2]<=0;
                            counter3s3<=0;
                       end//if the time is over, clear all relative registers
                   end
                 end
                
                   if(timer3>63)//if stimulate lasts for more than 6sec, consider multiple situations below:
                   begin
                   if(energysv[2]==1)
                   begin
                     counter3<=counter3+1;
                       if (counter3>=5)//in energy saving, light up floor 3 for 0.5s
                       begin
                            light3<=0;
                            counter3<=0;
                            timer3<=0;
                            lghttime3<=0;
                            energysv[2]<=0;
                            counter3s3<=0;
                       end//if the time is over, clear all relative registers
                   end
                   
                     if(flag3==0)
                     begin
                       light3<=1;
                     end
                       if(flag3==1)
                         //if stimulate lasts for more than 6sec and didn't enter energy saving mode, let flag=1
                         //then turn off the light until 3sec after the disappearance of the stimulate
                       begin
                         if(counter3s3<=30)
                         begin
                           counter3s3<=counter3s3+1;
                         end
                         if(energysv[2]==1)
                         begin
                           counter3s3<=0;
                         end
                         if(counter3s3>30)
                           //if 3sec passed and didn't enter energy saving mode, then turn off the light
                         begin
                           flag3<=0;
                           counter3s3<=0;
                           timer3<=0;
                           lghttime3<=0;
                           light3<=0;
                           energysv[2]<=0;
                         end//turn the light and clear all of the relevant registers
                       end
                   end
      end
      if(stimulate==4'b0001||timer4>=3)
        //to enter this if block, when the  stimulate  appears for less than 3sec, stimulate==4'b1000
        //when the stimulate lasts for more than 0.3sec, whether or not it disappears, timer1>=3, start if
      begin
                 if(timer4<=68)
                 begin
                 timer4<=(timer4+1);//begin timing when the stimulate appears
                 end

                 if(timer4<3&&stimulate!=4'b0001)
                 begin
                   timer4<=0;//if the stimulate lasts for less than 0.3sec, regard it as a disruption, clear timer4
                 end
                 
                 if(timer4>=3&&timer4<=63)
                   //if the stimulate lasts for more than 0.3sec,turn on the light for 6s if it didn't enter energy saving mode
                 begin
                   if(lghttime4<56)
                   begin
                   light4<=1;//turn on the light of 4th floor
                   lghttime4=lghttime4+1;//count for light time
                   end
                   if(energysv[3]==1||(lghttime4==56&&stimulate!=4'b0001))
                   //whether or not energy saving mode is on, turn on the light in the last 0.5sec of 6s
                   begin
                     counter4<=1+counter4;
                       if (counter4>=5)//in energy saving mode, light up floor 4 for 0.5s then turn off
                       begin
                            light4<=0;
                            counter4<=0;
                            timer4<=0;
                            lghttime4<=0;
                            energysv[3]<=0;
                            counter3s4<=0;
                       end//if the time is over, clear all relative registers
                   end
                 end
                
                   if(timer4>63)//if stimulate lasts for more than 6sec, consider multiple situations below:
                   begin
                   if(energysv[3]==1)
                   begin
                     counter4<=counter4+1;
                       if (counter4>=5)//in energy saving, light up floor 4 for 0.5s
                       begin
                            light4<=0;
                            counter4<=0;
                            timer4<=0;
                            lghttime4<=0;
                            energysv[3]<=0;
                            counter3s4<=0;
                       end//if the time is over, clear all relative registers
                   end
                   
                     if(flag4==0)//when stimulate exists when time>6s
                     begin
                       light4<=1;
                     end
                     if(flag4==1)
                       //if stimulate lasts for more than 6sec and didn't enter energy saving mode, let flag=1
                       //then turn off the light until 3sec after the disappearance of the stimulate
                     begin
                       if(counter3s4<=30)
                       begin
                         counter3s4<=counter3s4+1;
                       end
                       if(energysv[3]==1)
                       begin
                         counter3s4<=0;
                       end
                       if(counter3s4>30)
                         //if 3sec passed and didn't enter energy saving mode, then turn off the light
                       begin
                        flag4<=0;
                        counter3s4<=0;
                        timer4<=0;
                        lghttime4<=0;
                        light4<=0;
                        energysv[3]<=0;
                      end//turn the light and clear all of the relevant registers
                    end
                 end
         end
end


always@(stimulate)//monitor any changes in stimulate
begin
  if(timer1>63||timer2>63||timer3>63||timer4>63)//any of each floors is lighted for more than 6s
  begin
    
    if(stimulate!=4'b1000)
    begin
      flag1<=1;//if floor1 doesn't recieve any stimulate signal let flag1=1, let count3s2 count down 3s
    end
    else
    begin
      flag1<=0;//if  there is still stimulate, keep waiting till its  absence
    end
  
    if(stimulate!=4'b0100)
    begin
      flag2<=1;//if floor2 doesn't recieve any stimulate signal let flag2=1, let count3s2 count down 3s
    end
    else
    begin
      flag2<=0;//if  there is still stimulate, keep waiting till its  absence
    end
    
    if(stimulate!=4'b0010)
    begin
      flag3<=1;//if floor3 doesn't recieve any stimulate signal let flag3=1, let count3s3 count down 3s
    end
    else
    begin
      flag3<=0;//if  there is still stimulate, keep waiting till its  absence
    end
    
    if(stimulate!=4'b0001)
    begin
      flag4<=1;//if floor4 doesn't recieve any stimulate signal let flag4=1, let count3s4 count down 3s
    end
    else
    begin
      flag4<=0;//if  there is still stimulate, keep waiting till its  absence
    end
    
  end
end

always@(posedge light2)//waiting for a posedge of light in 2nd floor as a signal of entrance of energy saving mode
begin
  if(light1==1)
  begin
  energysv[0]<=1;//let floor 1 enter energy saving mode 
  counter3s1<=0;
  end
end

always@(posedge light1 or posedge light3)
//waiting for a posedge of light in 1st floor or 3rd floor as a signal of entrance of energy saving mode
begin
  if(light2==1)
  begin
  energysv[1]<=1;//let floor 2 enter energy saving mode 
  counter3s2<=0;
  end
end

always@(posedge light2 or posedge light4)
//waiting for a posedge of light in 2nd floor or 4th floor as a signal of entrance of energy saving mode
begin
  if(light3==1)
  begin
  energysv[2]<=1;//let floor 3 enter energy saving mode 
  counter3s3<=0;
  end
end

always@(posedge light3)//waiting for a posedge of light in 3rd floor as a signal of entrance of energy saving mode
begin
  if(light4==1)
  begin
  energysv[3]<=1;//let floor 4 enter energy saving mode
  counter3s4<=0;
  end
end

endmodule
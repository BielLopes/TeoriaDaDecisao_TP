/*********************************************
 * OPL 22.1.0.0 Model
 * Author: tutag
 * Creation Date: Jun 29, 2022 at 2:14:53 AM
 *********************************************/

int NbItems = ...;
int NbResources = ...;

range Items = 1..NbItems;
range Resources = 1..NbResources;

int Capacity[Resources] = ...;
int Volume[Resources] = ...;

int Value[Items] = ...;
int Quantity[Items] = ...;

int UseCapacity[Items] = ...;
int UseVolume[Items] = ...;

int MaxValue = max(r in Resources) Volume[r];
 
 
dvar int Take[Resources][Items] in 0..MaxValue;
 
maximize
	sum(i in Items, r in Resources) Value[i] * Take[r][i];
   

subject to {
  
  // Não excede o Volume
  forall( r in Resources )
  		sum (i in Items)
			UseVolume[i] * Take[r][i] <= Volume[r];
			
  // Não excede a Capacidade
  forall( r in Resources )
	    sum( i in Items ) 
			UseCapacity[i] * Take[r][i] <= Capacity[r];
  
  // Não excede a quantidade de itens
  forall(i in Items)
    sum (r in Resources)
      Take[r][i] <= Quantity[i];
   
   // Garante que pegamos pelo menos um de cada
   forall(i in Items)
     sum(r in Resources)
       Take[r][i] >= 1;
}
 

tuple TakeSolutionT{ 
	int resource;
	int item; 
	int value; 
};


{TakeSolutionT} TakeSolution = {<r0, i0, Take[r0][i0]> | r0 in Resources, i0 in Items};
execute{ 
	writeln(TakeSolution);
	write("C:\\Users\\tutag\\opl\\teste-cplex\\solution.txt");
}
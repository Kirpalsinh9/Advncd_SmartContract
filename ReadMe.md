-Submitted By:-
Kirpalsinh Vaghela

Use Case:

This is just a lottery contract, in which anyone can bet some ethers through Enterlottery(). There are some functions that are only called by the owner of the contract. There is also one private function called random() that has been used in another function to choose the winner of the lottery randomly.
This  Lottery contract uses  LibforChangeOwner library that changes the onwer of the Lottery.
There is one another contract called Factory that is used in another contract called Dashboard and through Dashboard we can run all the funcationality of the main contract Lottery. We can also deploy number of Lotteries through Dashboard or Factory and then, we can run any function of Lottery by just passing the id of the lottery through Dashboard contract.

Adresses On Kovan TestNet:

Factory:0x65663f40aa3ac97f60d7a8c7d37531d1f1c358d6

Dashboard:0xcc12db2761afffa03970645a1591bff2b6ec7106


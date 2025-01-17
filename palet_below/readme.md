# PALET FROM BELOW
This section explains briefly how the _cadenes_widthMeasure_ script works.
> [!NOTE]
> The following videos explain in greater details how this code works: [Measure the width of the palet](https://youtu.be/EDoIp1sn0Ss), [Check the integrity of the palet](https://youtu.be/rwk_BLinRDQ)


In this part, we will be looking at the pallet with the following point of view:
![13dddae0-8ec8-40e7-8dec-b86768fde054](https://github.com/user-attachments/assets/a819c2e9-0015-42a5-9ca1-216cf8a4bf2e)
In this case, the pallet would move from top to down, and the camera would record the whole pallet moving.
Note that some cardboard pieces are present. They represent the parts masked by the chains moving the pallet. We cannot detect anything in these parts.

We get the following image, where the purple lines represent blind spots: 
<div align="center">
    <img height="60%" width="60%" alt="Image" src="https://github.com/user-attachments/assets/8a8bbb41-2eaa-4f91-9a91-412443ea8c3b">
</div>

To classify the pallet, we can reconstruct a certain pattern to check whether it is in good condition or not. 
If we were to look in the same direction as the arrow: 
<div align="center">
    <img height="60%" width="60%" alt="Image" src="https://github.com/user-attachments/assets/5ac15fcf-ba00-47f4-8fa3-57193b0ad929">
</div>
The pattern we would obtain is as follows: 
<div align="center">
    <img height="60%" width="60%" alt="Image" src="https://github.com/user-attachments/assets/18bb9cb3-7332-4a70-ab97-5a99d5efae67">
</div>
And, once processed by the camera we would obtain the following result: 
<div align="center">
    <img height="80%" width="80%" alt="Image" src="https://github.com/user-attachments/assets/7e226e21-276f-4e00-8c97-8ee13121cd8b">
</div>

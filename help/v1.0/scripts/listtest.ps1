#Single list object test

$VMHypervisorList1 = "172.30.75.183"#,"172.30.75.184"

#taking the list and outputting an array of objects
function New-VMHypervisorArray($VMHypervisorList1)
{
    $list = New-Object System.Collections.Generic.List[System.String]
    #Add each host in the given list to an array for later use
    foreach ($hypervisor in $VMHypervisorList1)
    {
        #Add a hypervisor to a list
        $list.Add($hypervisor)
    }
    #Convert the List objects back to Array types for later use.
    $VMHypervisorArray1 = $list.ToArray()
    #write Array object to pipeline for later use
    Write-Output $VMHypervisorArray1
}

#assign runction output to variable
$VMHypervisorArray1 = New-VMHypervisorArray -VMHypervisorList $VMHypervisorList1
#try to grab first object of array variable
$VMHypervisorArray1[0]

#clear array object to restart test
$VMHypervisorArray1 = $null


#multiple list object test

$VMHypervisorList2 = "172.30.75.183","172.30.75.184"

#taking the list and outputting an array of objects
function New-VMHypervisorArray($VMHypervisorList2)
{
    $list = New-Object System.Collections.Generic.List[System.String]
    #Add each host in the given list to an array for later use
    foreach ($hypervisor in $VMHypervisorList2)
    {
        #Add a hypervisor to a list
        $list.Add($hypervisor)
    }
    #Convert the List objects back to Array types for later use.
    $VMHypervisorArray2 = $list.ToArray()
    #write Array object to pipeline for later use
    Write-Output $VMHypervisorArray2
}

#assign runction output to variable
$VMHypervisorArray2 = New-VMHypervisorArray -VMHypervisorList $VMHypervisorList2
#try to grab first object of array variable
$VMHypervisorArray2[0]

#clear array object to restart test
$VMHypervisorArray = $null

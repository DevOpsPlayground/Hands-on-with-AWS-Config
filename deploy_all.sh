source .env

destroy=0


if [ -z "$3" ]
then
    destroy=0
else
    if [ "$3" = "yes" ]; then
        destroy=1
    fi
fi





for i in $(find . -iname "scenario*"); do
    cd $i/tf
    pwd

    
    if [ ! -d .terraform ]; then
        terraform init
    fi
        
    mkdir -p "arch"

    for y in $(seq $1 $2); do 

        this_dir=$(pwd)

        mkdir -p "arch/${y}"


        cd "arch/${y}"
       
    
        echo "moving previous state files, if any"
        mv ** ../../
    
        
        cd ../../

    if [ "$destroy" = 1 ]; then
        echo "destroying"
        TF_VAR_AWS_KEY=$AWS_KEY TF_VAR_AWS_SEC=$AWS_SECRET TF_VAR_DPG_USER="user${y}" terraform destroy -auto-approve
    else
        echo "deploying"
        TF_VAR_AWS_KEY=$AWS_KEY TF_VAR_AWS_SEC=$AWS_SECRET TF_VAR_DPG_USER="user${y}" terraform plan
        TF_VAR_AWS_KEY=$AWS_KEY TF_VAR_AWS_SEC=$AWS_SECRET TF_VAR_DPG_USER="user${y}" terraform apply -auto-approve

    fi

       
        mv .terraform.* "arch/${y}/"
        mv *.tfstat* "arch/${y}/"
   
   
    # cd ../../
    #     echo $y; 
    #     mkdir "archive${y}"
    #     mv *.tfstate* "archive${y}"
    # export DPG_USER="user${y}"
    # cd $i/tf
    # tplan
    # tapply -auto-approve
    # cd ../../
    done
    pwd 
    cd ../../
done
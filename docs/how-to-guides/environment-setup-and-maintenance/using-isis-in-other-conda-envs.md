# Using ISIS in other Conda Environments

<div class="grid cards" markdown>

- [:octicons-arrow-left-24: Setting up the  __ISIS Data Area__](../../how-to-guides/environment-setup-and-maintenance/isis-data-area.md)

</div>

The ISIS conda package pins some of its requirements, 
which may clash with other packages. 

Therefore, if you want to use ISIS in conjunction with other conda packages, 
we recommend that you ***avoid*** adding other packages to the environment 
you create when you 
[install ISIS](../../how-to-guides/environment-setup-and-maintenance/installing-isis-via-anaconda.md). 
This is similar to the best-practice of keeping your 
`base` conda environment free of extra conda packages.

Instead, when you need to run ISIS programs in other conda environments, try **Stacking**.  Or, for some more complex scenarios, you can try *editing the activation script*.

-----

## Stacking (Easy)

Create a working environment (we call ours `working` in this tutorial) and add the conda packages you need.

To stack environments, first activate your `isis` environment.  Then activate your `working` env on top of your isis env with the `--stack` argument.

```sh
conda activate isis
conda activate --stack working
```

That's it, your `working` env is now stacked on top of your `isis` env.

!!! note "Exiting stacked environments: run `conda deactivate` twice"

    You'll have to run `conda deactivate` two times to exit your conda environments: once to get out of `working`, and then once more to get out of `isis`.

-----

## Editing the Activation Script (Hard)

Stacking might not work if you have 
a complex set of packages/dependencies,
so here's one alternative: editing the activation script.

!!! warning

    If you aren't comfortable following these steps
    for editing the activation script, contact your
    system administrator.

In theory, all you really need in your `working` env are the
ISIS environmental variables and the path to the ISIS apps.  You can set those up by customizing your conda env's `activate.d/` and `deactivate.d/` directories.

1.  **Working Env**  
    Create your `working` conda env and add the packages you need.  
    </br>

1.  **Base Conda Prefix**  
    Locate the path to your base conda environment.

        echo $CONDA_PREFIX

    Our Result: `~/miniconda3`.  
    You should use your own result from the above command.  
    </br>

1.  **ISIS Conda Prefix**  
    Locate the path to your ISIS conda environment:

        conda activate isis
        echo $CONDA_PREFIX

    Our Result: `~/miniconda3/envs/isis`.  

    You can do the same thing to find the path to your `working`
    environment, our result being `~/miniconda3/envs/working`.  
    </br>

1.  **Copy Scripts**  
    Copy the ISIS activation and deactivation scripts to your new
    environment.
    
    !!! warning "Don't just copy & paste our commands, use your own system details."

        For steps 4-6, use your own **env names** and **folder names**, don't just copy and paste.  If your shell *doesn't use bash*, you may need to use a different `env_vars.*` file, and/or different command syntax.

    ```sh
    # Go to your conda envs folder
    cd ~/miniconda3/envs/

    # create activate.d and deactivate.d folders in your 'working' env
    mkdir -p working/etc/conda/activate.d/
    mkdir -p working/etc/conda/deactivate.d/

    # Copy activation and deactivation scripts
    # from your 'isis' env to your 'working' env.
    cp isis/etc/conda/activate.d/env_vars.sh working/etc/conda/activate.d/env_vars.sh
    cp isis/etc/conda/deactivate.d/env_vars.sh working/etc/conda/deactivate.d/env_vars.sh
    ```  
    </br>


1.  **Add /bin to path at Activation**  
    Edit the copied activation file in
    `~/miniconda3/envs/working/etc/conda/activate.d/` to add the
    ISIS executable directory to the path, by adding this line at the
    end:

    ```sh
    export PATH=$PATH:$ISISROOT/bin
    ```

    It's important to add `$ISISROOT/bin` to the end of the path in your
    working environment, not the beginning.  
    </br>

1.  **Remove /bin from path at Deactivation**  
    Edit the copied deactivation file in
    `$HOME/anaconda3/envs/working/etc/conda/deactivate.d/` to remove
    the path, by adding this line at the end:

    ```sh
    export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '/isis/ {next} {print}' | sed 's/:$//'`;`
    ```

    (`isis` here being the name of your isis env.  You can look in
    the `activate.d/env_vars.sh` file to see what it should be.)
#!/bin/bash

if [ -z "${VIRTUAL_ENV}" ]; then
    echo "Please activate a virtualenv first";
    exit
fi

if [ ! -f requirements.txt ]; then
    echo "Please run this script in it's own directory"
    exit
fi

#./install_zeromq.sh
pip install -r requirements.txt
#pip install -r requirements-ztask.txt --install-option="--zmq=${VIRTUAL_ENV}"

wget http://code.djangoproject.com/svn/django/trunk/extras/django_bash_completion -O ${VIRTUAL_ENV}/bin/django_bash_completion

POSTACTIVATE=${VIRTUAL_ENV}/bin/postactivate

if [ -x ${POSTACTIVATE} ]; then
    echo -e 'Adding django_bash_completion to postactivate'
    echo -e 'source ${VIRTUAL_ENV}/bin/django_bash_completion' >> ${POSTACTIVATE}
else
    echo -e 'Creating postactivate'
    echo -e '#!/bin/bash\nsource ${VIRTUAL_ENV}/bin/django_bash_completion' >> ${POSTACTIVATE}
    chmod 755 ${POSTACTIVATE}
fi

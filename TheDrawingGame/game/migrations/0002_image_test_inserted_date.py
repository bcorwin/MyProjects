# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.utils.timezone import utc
import datetime


class Migration(migrations.Migration):

    dependencies = [
        ('game', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='image_test',
            name='inserted_date',
            field=models.DateTimeField(default=datetime.datetime(2015, 4, 14, 21, 53, 48, 508479, tzinfo=utc), auto_now_add=True),
            preserve_default=False,
        ),
    ]

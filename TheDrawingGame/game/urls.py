from django.conf.urls import patterns, url
from game import views

urlpatterns = patterns('',
    url(r'^canvas/$', views.canvas, name='canvas'),
    url(r'^image/(?P<ImageID>\d+)$', views.image, name='image'),
)
"""
URL configuration for django_revelation project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path

from django_revelation.revelationmap.views.route import RouteView
from django_revelation.revelationmap.views.sectors import SectorsView
from django_revelation.revelationmap.views.solarsystem import SolarSystemDetailView
from django_revelation.revelationmap.views.solarsystems import SolarSystemsView
from django_revelation.revelationmap.views.stars import StarsView
from django_revelation.revelationmap.views.system_map import system_map

urlpatterns = [
    path('admin/', admin.site.urls),
    path('route', RouteView.as_view(), name='route'),
    path('sectors', SectorsView.as_view(), name='sectors'),
    path('solarsystem', SolarSystemDetailView.as_view(), name='solarsystem'),
    path('solarsystems', SolarSystemsView.as_view(), name='solarsystems'),
    path('stars', StarsView.as_view(), name='stars'),
    path('systemmap', system_map, name='systemmap'),
]

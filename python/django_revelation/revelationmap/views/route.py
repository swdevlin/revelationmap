from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from rest_framework.response import Response
from rest_framework.views import APIView

from django_revelation.revelationmap.models import Route
from django_revelation.revelationmap.serializers import RouteSerializer


@method_decorator(csrf_exempt, name='dispatch')
class RouteView(APIView):
    def get(self, request):
        hexes = Route.objects.all().order_by('year', 'day', 'ship_id')
        serializer = RouteSerializer(hexes, many=True)
        return Response(serializer.data)

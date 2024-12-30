from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from rest_framework.response import Response
from rest_framework.views import APIView

from django_revelation.revelationmap.models import Sector
from django_revelation.revelationmap.serializers import SectorSerializer


@method_decorator(csrf_exempt, name='dispatch')
class SectorsView(APIView):
    def get(self, request):
        sectors = Sector.objects.all()
        serializer = SectorSerializer(sectors, many=True)
        return Response(serializer.data)

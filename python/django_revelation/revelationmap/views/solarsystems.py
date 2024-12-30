from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from rest_framework.response import Response
from rest_framework.views import APIView

from django_revelation.revelationmap.models import SolarSystem
from django_revelation.revelationmap.serializers import SolarSystemSerializer
from django_revelation.revelationmap.utils import parse_boundary, sector_regions, filter_clauses


@method_decorator(csrf_exempt, name='dispatch')
class SolarSystemsView(APIView):
    def get(self, request):
        boundary = parse_boundary(request)
        regions = sector_regions(boundary["ul"], boundary["lr"])
        filter = filter_clauses(regions)
        systems = SolarSystem.objects.filter(filter)
        serializer = SolarSystemSerializer(systems, many=True)
        return Response(serializer.data)

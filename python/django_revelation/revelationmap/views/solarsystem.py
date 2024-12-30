from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.exceptions import NotFound

from django_revelation.revelationmap.models import SolarSystem
from django_revelation.revelationmap.serializers import SolarSystemSerializer


class SolarSystemDetailView(APIView):
	def get(self, request):
		sx = request.query_params.get('sx')
		sy = request.query_params.get('sy')
		hx = request.query_params.get('hx')
		hy = request.query_params.get('hy')

		if not all([sx, sy, hx, hy]):
			return Response(
				{"error": "sx, sy, hx, hy are required"},
				status=400
			)

		try:
			solar_system = SolarSystem.objects.get(
				sector__x=int(sx),
				sector__y=int(sy),
				x=int(hx),
				y=int(hy)
			)
		except SolarSystem.DoesNotExist:
			raise NotFound("solar system not found")

		solar_system_data = SolarSystemSerializer(solar_system).data

		return Response(solar_system_data)

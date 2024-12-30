import os

from django.conf import settings
from django.http import HttpResponse, JsonResponse, FileResponse
from django.shortcuts import get_object_or_404

from django_revelation.revelationmap.models import Sector


def system_map(request):
    try:
        sx = request.GET.get('sx')
        sy = request.GET.get('sy')
        hex_code = request.GET.get('hex')  # 'hex' is a reserved keyword in Python, using 'hex_code'

        if not sx or not sy or not hex_code:
            return JsonResponse({'error': 'sx, sy, and hex query parameters are required'}, status=400)

        sector = get_object_or_404(Sector, x=int(sx), y=int(sy))

        file_path = os.path.join(
            settings.STELLAR_DATA,
            sector.name,
            f"{hex_code}-map.svg"
        )

        if not os.path.exists(file_path):
            return HttpResponse('SVG file not found', status=404)

        return FileResponse(open(file_path, 'rb'), content_type='image/svg+xml')

    except Exception as error:
        print(f"Error: {error}")
        return JsonResponse({'error': 'Failed to retrieve the sector or serve the SVG file'}, status=500)

from rest_framework import serializers
from .models import SolarSystem, Sector, Route


class SolarSystemSerializer(serializers.ModelSerializer):
    sector_x = serializers.IntegerField(source='sector.x', read_only=True)
    sector_y = serializers.IntegerField(source='sector.y', read_only=True)
    sector_name = serializers.CharField(source='sector.name', read_only=True)

    class Meta:
        model = SolarSystem
        fields = '__all__'
        extra_fields = [
            'sector_x', 'sector_y', 'sector_name'
        ]

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['sector_x'] = instance.sector.x if instance.sector else None
        representation['sector_y'] = instance.sector.y if instance.sector else None
        representation['sector_name'] = instance.sector.name if instance.sector else None
        return representation


class SolarSystemStarsSerializer(serializers.ModelSerializer):
    sector_x = serializers.IntegerField(source='sector.x', read_only=True)
    sector_y = serializers.IntegerField(source='sector.y', read_only=True)
    sector_name = serializers.CharField(source='sector.name', read_only=True)

    class Meta:
        model = SolarSystem
        fields = [
            'sector_x', 'sector_y', 'sector_name',
            'x', 'y', 'name', 
            'scan_points',
            'survey_index',
            'gas_giant_count',
            'terrestrial_planet_count',
            'planetoid_belt_count',
            'allegiance',
            'stars',

        ]


class SectorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sector
        fields = '__all__'


class RouteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Route
        fields = '__all__'

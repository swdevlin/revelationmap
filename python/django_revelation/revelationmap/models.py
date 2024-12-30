from django.db import models


class Sector(models.Model):
	x = models.IntegerField()
	y = models.IntegerField()
	name = models.CharField(max_length=256)
	abbreviation = models.CharField(max_length=256)

	class Meta:
		managed = False
		db_table = 'sector'
		unique_together = (('x', 'y'),)


class SolarSystem(models.Model):
	sector = models.ForeignKey(Sector, on_delete=models.CASCADE)
	x = models.IntegerField()
	y = models.IntegerField()
	name = models.CharField(max_length=256)
	scan_points = models.IntegerField()
	survey_index = models.IntegerField()
	gas_giant_count = models.IntegerField()
	planetoid_belt_count = models.IntegerField()
	terrestrial_planet_count = models.IntegerField()
	bases = models.TextField(blank=True, null=True)
	remarks = models.TextField(blank=True, null=True)
	native_sophont = models.BooleanField(default=False)
	extinct_sophont = models.BooleanField(default=False)
	star_count = models.IntegerField()
	main_world = models.JSONField(blank=True, null=True)
	primary_star = models.JSONField()
	stars = models.JSONField()
	allegiance = models.TextField(blank=True, null=True)

	class Meta:
		managed = False
		db_table = 'solar_system'
		unique_together = (('sector', 'x', 'y'),)

from django.core.exceptions import BadRequest
from django.db.models import Q


class HexAddress:
	def __init__(self, sx, sy, hx=None, hy=None):
		self.sx = sx
		self.sy = sy
		self.hx = hx
		self.hy = hy


class Region:
	def __init__(self, sx, sy, minX, maxX, minY, maxY):
		self.sx = sx
		self.sy = sy
		self.minX = minX
		self.maxX = maxX
		self.minY = minY
		self.maxY = maxY


def parse_boundary(request):
	try:
		ulsx = request.GET.get('ulsx')
		ulsy = request.GET.get('ulsy')
		ulhx = request.GET.get('ulhx')
		ulhy = request.GET.get('ulhy')
		lrsx = request.GET.get('lrsx')
		lrsy = request.GET.get('lrsy')
		lrhx = request.GET.get('lrhx')
		lrhy = request.GET.get('lrhy')

		if ulsx is None or ulsy is None:
			raise BadRequest("upper left sector x and y are required")

		if lrsx is not None and lrsy is not None:
			if (
				ulhx is None or ulhy is None or
				lrhx is None or lrhy is None or
				int(ulsx) > int(lrsx) or int(ulsy) < int(lrsy)
			):
				raise BadRequest("hex x and y incorrect")

		ul = HexAddress(
			sx=int(ulsx),
			sy=int(ulsy),
			hx=int(ulhx) if ulhx else None,
			hy=int(ulhy) if ulhx else None,

		)

		lr = HexAddress(
			sx=int(lrsx),
			sy=int(lrsy),
			hx=int(lrhx) if lrhx else None,
			hy=int(lrhy) if lrhx else None,
		)

		return {"ul": ul, "lr": lr}

	except Exception as error:
		print(error)
		raise BadRequest("invalid query parameters")


def sector_regions(ul, lr=None):
	regions = []

	if lr is None:  # Check if the lower-right address is missing
		regions.append(Region(
			sx=ul.sx,
			sy=ul.sy,
			minX=1,
			maxX=32,
			minY=1,
			maxY=40,
		))
	else:
		if ul.sx == lr.sx and ul.sy == lr.sy:
			regions.append(Region(
				sx=ul.sx,
				sy=ul.sy,
				minX=ul.hx,
				maxX=lr.hx,
				minY=ul.hy,
				maxY=lr.hy,
			))
		else:
			for x in range(ul.sx, lr.sx + 1):
				for y in range(ul.sy, lr.sy - 1, -1):
					if x == ul.sx:
						minX = ul.hx
						maxX = lr.hx if x == lr.sx else 32
					elif ul.sx < x < lr.sx:
						minX = 1
						maxX = 32
					else:
						minX = 1
						maxX = lr.hx

					if y == ul.sy:
						minY = ul.hy
						maxY = lr.hy if y == lr.sy else 40
					elif ul.sy > y > lr.sy:
						minY = 1
						maxY = 40
					else:
						minY = 1
						maxY = lr.hy

					regions.append(Region(
						sx=x,
						sy=y,
						minX=minX,
						maxX=maxX,
						minY=minY,
						maxY=maxY,
					))

	return regions


def filter_clauses(regions):
	query = Q()
	for region in regions:
		query |= Q(
			sector__x=region.sx,
			sector__y=region.sy,
			x__range=(region.minX, region.maxX),
			y__range=(region.minY, region.maxY),
		)

	return query

from django.db import models

class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)
    slug = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = 'categories'
        verbose_name_plural = 'Categories'

    def __str__(self):
        return self.name


class MachineryModel(models.Model):
    brand = models.CharField(max_length=100)
    model_name = models.CharField(max_length=100)
    model_year = models.IntegerField(blank=True, null=True)
    sku_prefix = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'machinery_models'

    def __str__(self):
        return f"{self.brand} {self.model_name} ({self.model_year})"


class Part(models.Model):
    category = models.ForeignKey(Category, models.DO_NOTHING)
    part_number = models.CharField(max_length=50, unique=True)
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    stock_quantity = models.IntegerField()
    image_url = models.CharField(max_length=512, blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'parts'

    def __str__(self):
        return f"{self.part_number} - {self.name}"


class PartCompatibility(models.Model):
    part = models.ForeignKey(Part, models.DO_NOTHING, primary_key=True) 
    machinery = models.ForeignKey(MachineryModel, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'part_compatibilities'
        unique_together = (('part', 'machinery'),)
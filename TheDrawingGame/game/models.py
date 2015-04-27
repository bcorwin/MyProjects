from django.db import models

class Image_test(models.Model):
    image = models.CharField('Image',max_length=10000000)
    inserted_date = models.DateTimeField(auto_now_add=True, blank=True)
    
    def __str__(self):
        return str(self.id)
from PIL import Image
import numpy as np
import sys
from os.path import join
from os import listdir

pack_name = "liam-playground"
sprite = "body0"
layer = "base"
rows = 1
cols = 1

export_path = join("export", pack_name, sprite)
col_files = list(sorted(x for x in listdir(export_path) if x.startswith(layer + "_col_")))
msk_files = list(sorted(x for x in listdir(export_path) if x.startswith(layer + "_msk_")))
nor_files = list(sorted(x for x in listdir(export_path) if x.startswith(layer + "_nor_")))
alpha_files = list(sorted(x for x in listdir(export_path) if x.startswith(layer + "_alpha_")))

col_imgs = [np.asarray(Image.open(join(export_path, f)).transpose(Image.ROTATE_270)) for f in col_files]
msk_imgs = [np.asarray(Image.open(join(export_path, f)).transpose(Image.ROTATE_270)) for f in msk_files]
h, w = col_imgs[0].shape[:2]
sheet = np.zeros((h*rows, w*cols, 4), dtype=np.uint8)

x, y = 0, 0
for col, msk in zip(col_imgs, msk_imgs):
    sheet[y:y+h, x:x+w, :3] = col[:, :, :3]
    sheet[y:y+h, x:x+w, 3] = msk[:, :, 0]
    x += w
    if x >= w*cols:
        x = 0
        y += h

Image.fromarray(sheet).save(join("packs", pack_name, sprite, layer + "_col.png"))

nor_imgs = [np.asarray(Image.open(join(export_path, f)).transpose(Image.ROTATE_270)) for f in nor_files]
alpha_imgs = [np.asarray(Image.open(join(export_path, f)).transpose(Image.ROTATE_270)) for f in alpha_files]
h, w = nor_imgs[0].shape[:2]
sheet = np.zeros((h*rows, w*cols, 4), dtype=np.uint8)

x, y = 0, 0
for nor, alpha in zip(nor_imgs, alpha_imgs):
    sheet[y:y+h, x:x+w, 0] = nor[:, :, 1]
    sheet[y:y+h, x:x+w, 1] = nor[:, :, 0]
    sheet[y:y+h, x:x+w, 3] = alpha[:, :, 0]
    x += w
    if x >= w*cols:
        x = 0
        y += h

Image.fromarray(sheet).save(join("packs", pack_name, sprite, layer + "_nm.png"))


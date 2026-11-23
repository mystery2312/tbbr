/* The Big Black Rig — catalogue des blocs, presets d'usine, IR de démo.
 * Scripts classiques (pas de modules) : nginx met les assets en cache,
 * index.php les versionne un par un. */
'use strict';

const COLS = 8, LANE_LETTERS = 'AB', SCENES = 8, BANKS = 20, PER_BANK = 4, PRESETS = BANKS * PER_BANK, IR_SLOTS = 32, NAM_SLOTS = 16;
const SCENE_LETTERS = 'ABCDEFGH';
const SCENE_NAMES = ['Rhythm', 'Lead', 'Clean', 'Solo', 'Ambience', 'Scene F', 'Scene G', 'Scene H'];
const PRESET_COLORS = ['#ff4d4d', '#ff9f1a', '#f5d90a', '#3ddc84', '#2fd6c5', '#3aa0ff', '#b06cff', '#ff5fb0', '#9aa3ad'];
const NOTE_NAMES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

const CATS = {
  dyn:    { name: 'Dynamique',  short: 'DYN', color: '#3ddc84' },
  drive:  { name: 'Overdrive',  short: 'DRV', color: '#ff9f1a' },
  amp:    { name: 'Ampli',      short: 'AMP', color: '#ff4d4d' },
  cab:    { name: 'Cab / IR',   short: 'CAB', color: '#c98a55' },
  eq:     { name: 'Égaliseur',  short: 'EQ',  color: '#f5d90a' },
  mod:    { name: 'Modulation', short: 'MOD', color: '#b06cff' },
  pitch:  { name: 'Pitch',      short: 'PIT', color: '#ff5fb0' },
  delay:  { name: 'Delay',      short: 'DLY', color: '#3aa0ff' },
  reverb: { name: 'Reverb',     short: 'REV', color: '#2fd6c5' },
  util:   { name: 'Utilitaire', short: 'UTL', color: '#9aa3ad' },
};

/* Glyphes SVG par catégorie (viewBox 0 0 24 24, trait). */
/* Icônes (viewBox 0 0 24 24, trait) : une par type d'effet, pour reconnaître
 * un bloc sans texte. CAT_GLYPH sert de repli par catégorie. */
const MODEL_GLYPH = {
  gate:    '<path d="M3 12h3M18 12h3M6 5v14M18 5v14M6 9h12M6 15h12M10 9v6M14 9v6"/>',
  comp:    '<path d="M12 2v6M9 5l3 3 3-3M12 22v-6M9 19l3-3 3 3M3 12h18"/>',
  squash:  '<path d="M12 2v6M9 5l3 3 3-3M12 22v-6M9 19l3-3 3 3M3 12h18"/>',
  boost:   '<path d="M12 18V5M6 11l6-6 6 6M5 21h14"/>',
  green:   '<path d="M13 2L5 13h6l-1 9 8-12h-6z"/>',
  gold:    '<path d="M13 2L5 13h6l-1 9 8-12h-6z"/>',
  grit:    '<path d="M2 15V9h4v6h4V9h4v6h4V9h4v6"/>',
  metal:   '<path d="M2 15V9h4v6h4V9h4v6h4V9h4v6"/><path d="M2 19h20" opacity=".5"/>',
  fuzz:    '<path d="M2 13l3-7 2.5 12L10 6l2.5 12L15 6l2.5 12L20 6l2 7"/>',
  usclean: '<rect x="2.5" y="5" width="19" height="14" rx="2"/><path d="M2.5 10h19M5 13.5h14M5 16h14"/><circle cx="6" cy="7.5" r=".9"/><circle cx="9.5" cy="7.5" r=".9"/><circle cx="13" cy="7.5" r=".9"/>',
  nam:     '<circle cx="5" cy="7" r="2"/><circle cx="5" cy="17" r="2"/><circle cx="12" cy="5" r="2"/><circle cx="12" cy="12" r="2"/><circle cx="12" cy="19" r="2"/><circle cx="19" cy="12" r="2"/><path d="M7 7l3-1.5M7 8l3.4 3M7 16l3.4-3M7 17l3 1.5M14 6l3.6 4.8M14 12h3M14 18l3.6-4.8"/>',
  ir:      '<rect x="2.5" y="3" width="13" height="18" rx="2"/><circle cx="9" cy="13.5" r="3.5"/><circle cx="9" cy="6.5" r=".8"/><path d="M18.5 8v8M21.5 5v14"/>',
  cab412:  '<rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="3"/><circle cx="15.5" cy="8.5" r="3"/><circle cx="8.5" cy="15.5" r="3"/><circle cx="15.5" cy="15.5" r="3"/>',
  cab212:  '<rect x="2" y="6" width="20" height="12" rx="2"/><circle cx="7.5" cy="12" r="3.5"/><circle cx="16.5" cy="12" r="3.5"/>',
  peq:     '<path d="M2 17h4c3 0 3.5-11 6-11s3 11 6 11h4"/><path d="M2 20h20" opacity=".4"/>',
  geq:     '<path d="M5 4v16M10 4v16M15 4v16M20 4v16"/><path d="M3.5 14h3M8.5 8h3M13.5 11h3M18.5 16h3"/>',
  chorus:  '<path d="M2 9c2.5-5 5-5 7.5 0s5 5 7.5 0 3.5-3 5-2"/><path d="M2 15c2.5-5 5-5 7.5 0s5 5 7.5 0 3.5-3 5-2" opacity=".55"/>',
  flanger: '<path d="M2 12c3-7 5 7 8 0s4 7 6 0 3 5 6 0"/><path d="M4 19h16M17 16l3 3-3 3" opacity=".6"/>',
  phaser:  '<circle cx="12" cy="12" r="9"/><path d="M6 12c1.5-3.5 3-3.5 4.5 0s3 3.5 4.5 0 1.5-2.5 3-1.5"/>',
  trem:    '<path d="M2 12c1-3 2-3 3 0s2 3 3 0M8 12c1-7 2-7 3 0s2 7 3 0M14 12c1-3 2-3 3 0s2 3 3 0"/>',
  vibe:    '<path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12z"/><path d="M8.5 12c1-2 2.5-2 3.5 0s2.5 2 3.5 0"/>',
  rotary:  '<path d="M20 12a8 8 0 0 1-14.3 4.9M4 12a8 8 0 0 1 14.3-4.9"/><path d="M18.6 3v4.2h-4.2M5.4 21v-4.2h4.2"/>',
  octave:  '<path d="M10 17V5l6-1.5"/><circle cx="7.8" cy="17" r="2.2"/><path d="M19 10v9M16.5 16.5L19 19l2.5-2.5"/>',
  shift:   '<path d="M8 17V5l6-1.5"/><circle cx="5.8" cy="17" r="2.2"/><path d="M18.5 3v7M16 5.5L18.5 3 21 5.5M18.5 14v7M16 18.5l2.5 2.5 2.5-2.5"/>',
  harm:    '<path d="M8 18V6l11-2.5v12"/><circle cx="5.8" cy="18" r="2.2"/><circle cx="16.8" cy="15.5" r="2.2"/><path d="M8 9.5l11-2.5"/>',
  ddl:     '<path d="M4 5v14M9 7.5v9M14 9.5v5M19 11v2"/>',
  analog:  '<circle cx="5" cy="12" r="3"/><circle cx="12" cy="12" r="2.2" opacity=".7"/><circle cx="18" cy="12" r="1.5" opacity=".45"/>',
  tape:    '<rect x="2" y="5" width="20" height="14" rx="2"/><circle cx="8" cy="11" r="2.5"/><circle cx="16" cy="11" r="2.5"/><path d="M6 19l2-3h8l2 3"/>',
  pingpong:'<path d="M2 18c2-11 5-11 7 0 2-7 4-7 6 0 1.5-4 3-4 4.5 0"/><circle cx="21" cy="17" r="1.3"/>',
  reverse: '<path d="M5 11v2M10 9.5v5M15 7.5v9M20 5v14"/><path d="M8 3H3M5 1l-2 2 2 2" opacity=".7"/>',
  room:    '<path d="M3 20V8l9-5 9 5v12z"/><path d="M8 15a4 4 0 0 1 8 0M10.3 15a1.7 1.7 0 0 1 3.4 0"/>',
  hall:    '<path d="M2 21V10l10-7 10 7v11"/><path d="M8 21v-6a4 4 0 0 1 8 0v6M2 21h20"/>',
  plate:   '<rect x="3" y="8" width="18" height="9" rx="1"/><path d="M6 8V3M18 8V3M6.5 12.5h11"/>',
  spring:  '<path d="M2 12h1.5M20.5 12H22"/><path d="M3.5 12a2.2 3.5 0 1 1 4.3 0a2.2 3.5 0 1 1 4.3 0a2.2 3.5 0 1 1 4.3 0a2.2 3.5 0 1 1 4.1 0"/>',
  shimmer: '<path d="M12 2l2 7 7 2-7 2-2 9-2-9-7-2 7-2z"/><path d="M19 3v3M17.5 4.5h3" opacity=".7"/>',
  vol:     '<path d="M3 9h4l5-4v14l-5-4H3z"/><path d="M15.5 9a4 4 0 0 1 0 6M18.5 6a8 8 0 0 1 0 12"/>',
  fxl:     '<path d="M3 8h14l-3-3M21 16H7l3 3"/>',
};
['chime', 'brit', 'plexi', 'rect', 'lead51', 'bassamp'].forEach(id => { MODEL_GLYPH[id] = MODEL_GLYPH.usclean; });
const CAT_GLYPH = {
  dyn: MODEL_GLYPH.comp, drive: MODEL_GLYPH.green, amp: MODEL_GLYPH.usclean, cab: MODEL_GLYPH.cab412, eq: MODEL_GLYPH.geq,
  mod: MODEL_GLYPH.chorus, pitch: MODEL_GLYPH.shift, delay: MODEL_GLYPH.ddl, reverb: MODEL_GLYPH.hall, util: MODEL_GLYPH.vol,
};

/* ---- Définitions de paramètres ---- */
const k   = (id, name, def = 5, min = 0, max = 10, step = 0.1, unit = '') => ({ id, name, def, min, max, step, unit });
const db  = (id, name, def = 0, min = -12, max = 12) => k(id, name, def, min, max, 0.1, 'dB');
const pct = (id, name, def = 50) => k(id, name, def, 0, 100, 1, '%');
const ms  = (id, name, def, min, max) => k(id, name, def, min, max, 1, 'ms');
const hz  = (id, name, def, min, max, step = 1) => k(id, name, def, min, max, step, 'Hz');
const sel = (id, name, options, def = 0) => ({ id, name, type: 'select', options, def });
const tog = (id, name, def = false) => ({ id, name, type: 'bool', def });

const AMP = (extra = []) => [k('gain', 'Gain', 5), k('bass', 'Bass', 5), k('mid', 'Mid', 5), k('treb', 'Treble', 5), k('pres', 'Presence', 5), k('mast', 'Master', 5), ...extra];
const SYNC = ['Off', '1/4', '1/8.', '1/8', '1/8T', '1/16'];
const REV = (decay, extra = []) => [k('decay', 'Decay', decay, 0.1, 20, 0.1, 's'), ms('pre', 'Pre-delay', 20, 0, 250), pct('mix', 'Mix', 30), k('tone', 'Tone', 5), hz('lc', 'Low Cut', 100, 20, 800), ...extra];

const MODELS = [
  { id: 'gate',  cat: 'dyn', name: 'Noise Gate',  dsp: 8, params: [k('thr', 'Seuil', -60, -96, 0, 1, 'dB'), ms('rel', 'Release', 80, 5, 500), k('depth', 'Profondeur', -80, -96, 0, 1, 'dB')] },
  { id: 'comp',  cat: 'dyn', name: 'Studio Comp', dsp: 17, params: [k('thr', 'Seuil', -20, -60, 0, 1, 'dB'), k('ratio', 'Ratio', 4, 1, 20, 0.1, ':1'), k('att', 'Attaque', 10, 0.1, 100, 0.1, 'ms'), ms('rel', 'Release', 120, 10, 1000), pct('mix', 'Mix', 100), db('lvl', 'Niveau')] },
  { id: 'squash',cat: 'dyn', name: 'Squash Comp', dsp: 17, params: [k('sus', 'Sustain', 6), k('att', 'Attack', 4), pct('mix', 'Blend', 70), k('lvl', 'Level', 5)] },
  { id: 'boost', cat: 'dyn', name: 'Clean Boost', dsp: 5, params: [k('gain', 'Gain', 6, 0, 20, 0.1, 'dB'), k('tone', 'Tone', 5)] },

  { id: 'green', cat: 'drive', name: 'Green Scream 9', desc: 'Inspirée de l’Ibanez TS9 Tube Screamer', dsp: 15, params: [k('drv', 'Drive', 4), k('tone', 'Tone', 5), k('lvl', 'Level', 6)] },
  { id: 'od1',   cat: 'drive', name: 'Yellow Drive One', desc: 'Inspirée de la Boss OD-1', dsp: 16, params: [k('drv', 'Over Drive', 5), k('lvl', 'Level', 6)] },
  { id: 'sd1',   cat: 'drive', name: 'Yellow Super Drive', desc: 'Inspirée de la Boss SD-1', dsp: 15, params: [k('drv', 'Drive', 5), k('tone', 'Tone', 5), k('lvl', 'Level', 6)] },
  { id: 'bd2',   cat: 'drive', name: 'Blue Drive 2', desc: 'Inspirée de la Boss BD-2 Blues Driver', dsp: 18, params: [k('gain', 'Gain', 5), k('tone', 'Tone', 5), k('lvl', 'Level', 6)] },
  { id: 'gold',  cat: 'drive', name: 'Gold Horse', desc: 'Inspirée de la Klon Centaur', dsp: 15, params: [k('gain', 'Gain', 3), k('treb', 'Treble', 5), k('out', 'Output', 6)] },
  { id: 'grit',  cat: 'drive', name: 'Rodent Dist', desc: 'Inspirée de la ProCo RAT', dsp: 16, params: [k('dist', 'Distortion', 6), k('filt', 'Filter', 4), k('vol', 'Volume', 5)] },
  { id: 'muff',  cat: 'drive', name: 'Pi Fuzz', desc: 'Inspirée de l’Electro-Harmonix Big Muff Pi', dsp: 17, params: [k('sus', 'Sustain', 6), k('tone', 'Tone', 5), k('vol', 'Volume', 6)] },
  { id: 'fuzz',  cat: 'drive', name: 'Round Fuzz', dsp: 15, params: [k('fuzz', 'Fuzz', 7), k('vol', 'Volume', 5), tog('germ', 'Germanium', true)] },
  { id: 'metal', cat: 'drive', name: 'Metal Core', dsp: 16, params: [k('dist', 'Dist', 7), k('low', 'Low', 5), k('mid', 'Mid', 4), hz('mfq', 'Mid Freq', 800, 200, 5000, 10), k('high', 'High', 6), k('lvl', 'Level', 5)] },

  { id: 'usclean', cat: 'amp', name: 'US Double Clean', desc: 'Inspiré du Fender Twin Reverb', dsp: 29, params: AMP([tog('bright', 'Bright', true)]) },
  { id: 'chime',   cat: 'amp', name: 'Class A 30 TB', desc: 'Inspiré du Vox AC30 Top Boost', dsp: 34, params: [k('gain', 'Volume', 5), k('bass', 'Bass', 5), k('mid', 'Mid', 5), k('treb', 'Treble', 5), k('pres', 'Cut', 3), k('mast', 'Master', 5), sel('ch', 'Canal', ['Normal', 'Top Boost'], 1)] },
  { id: 'brit',    cat: 'amp', name: 'Brit 800 Lead', desc: 'Inspiré du Marshall JCM800 2203', dsp: 34, params: AMP() },
  { id: 'plexi',   cat: 'amp', name: 'Plexi 68', desc: 'Inspiré du Marshall Super Lead 1959', dsp: 29, params: AMP([sel('jump', 'Canaux', ['Normal', 'Bright', 'Jumped'], 2)]) },
  { id: 'rect',    cat: 'amp', name: 'Cali Rectified', desc: 'Inspiré du Mesa/Boogie Dual Rectifier', dsp: 38, params: AMP([sel('mode', 'Mode', ['Raw', 'Vintage', 'Modern'], 2), sel('rect', 'Redresseur', ['Tube', 'Diode'], 1)]) },
  { id: 'lead51',  cat: 'amp', name: 'Lead 5-1-50', desc: 'Inspiré du Peavey 5150 (canal Lead)', dsp: 37, params: AMP([k('res', 'Resonance', 5)]) },
  { id: 'nam',     cat: 'amp', name: 'NAM Loader',      dsp: 39, params: [{ id: 'slot', name: 'Capture', type: 'nam', def: 0 }, db('in', 'Entrée'), db('out', 'Sortie', 0, -24, 12), db('bass', 'Bass'), db('mid', 'Mid'), db('treb', 'Treble'), tog('norm', 'Normaliser', true)] },
  { id: 'bassamp', cat: 'amp', name: 'Bass SVx',        dsp: 15, params: [k('gain', 'Gain', 4), k('bass', 'Bass', 6), k('lmid', 'Lo-Mid', 5), k('hmid', 'Hi-Mid', 5), k('treb', 'Treble', 5), k('mast', 'Master', 5), tog('ultra', 'Ultra Lo', false)] },

  { id: 'ir',     cat: 'cab', name: 'IR Loader', dsp: 26, params: [{ id: 'slot', name: 'IR', type: 'ir', def: 0 }, hz('lc', 'Low Cut', 80, 20, 500), hz('hc', 'High Cut', 8000, 2000, 20000, 10), pct('mix', 'Mix', 100), db('lvl', 'Niveau')] },
  { id: 'cab412', cat: 'cab', name: '4x12 V30',  dsp: 21,  params: [sel('mic', 'Baffle', ['V30 SM57 A', 'V30 SM57 B', 'V30 Dyn 75', 'V30 + G12F', '4x12 fermé']), k('pos', 'Position', 3, 0, 10), k('dist', 'Distance', 2, 0, 10), hz('lc', 'Low Cut', 80, 20, 500), hz('hc', 'High Cut', 9000, 2000, 20000, 10)] },
  { id: 'cab212', cat: 'cab', name: 'Combo',     dsp: 22,  params: [sel('mic', 'Baffle', ['2x12 ouvert', '2x12 fermé', '2x12 mi-ouvert', '1x12 ouvert', '1x12 fermé', '4x10 ouvert'], 0), k('pos', 'Position', 4, 0, 10), k('dist', 'Distance', 2, 0, 10), hz('lc', 'Low Cut', 80, 20, 500), hz('hc', 'High Cut', 9000, 2000, 20000, 10)] },

  { id: 'peq', cat: 'eq', name: 'Parametric EQ', dsp: 7, params: [db('lf', 'Low'), db('lmf', 'Lo-Mid'), hz('lmq', 'Lo-Mid Hz', 400, 100, 2000, 10), db('hmf', 'Hi-Mid'), hz('hmq', 'Hi-Mid Hz', 2500, 1000, 8000, 10), db('hf', 'High'), db('lvl', 'Niveau')] },
  { id: 'geq', cat: 'eq', name: 'Graphic EQ 7',  dsp: 10, params: [db('b1', '100'), db('b2', '200'), db('b3', '400'), db('b4', '800'), db('b5', '1.6k'), db('b6', '3.2k'), db('b7', '6.4k'), db('lvl', 'Niveau')] },

  { id: 'chorus',  cat: 'mod', name: 'Chorus',   dsp: 7, params: [hz('rate', 'Rate', 0.8, 0.05, 10, 0.05), pct('depth', 'Depth', 50), pct('mix', 'Mix', 50), k('tone', 'Tone', 5)] },
  { id: 'flanger', cat: 'mod', name: 'Flanger',  dsp: 6, params: [hz('rate', 'Rate', 0.3, 0.05, 10, 0.05), pct('depth', 'Depth', 60), k('fb', 'Feedback', 50, -100, 100, 1, '%'), pct('mix', 'Mix', 50)] },
  { id: 'phaser',  cat: 'mod', name: 'Phaser',   dsp: 8, params: [hz('rate', 'Rate', 0.5, 0.05, 10, 0.05), pct('depth', 'Depth', 70), pct('fb', 'Feedback', 30), sel('st', 'Étages', ['4', '8', '12'])] },
  { id: 'trem',    cat: 'mod', name: 'Tremolo',  dsp: 5, params: [hz('rate', 'Rate', 4, 0.1, 15, 0.1), pct('depth', 'Depth', 60), sel('shape', 'Forme', ['Sine', 'Tri', 'Square']), sel('sync', 'Sync', SYNC)] },
  { id: 'vibe',    cat: 'mod', name: 'Uni-Vibe', dsp: 7, params: [k('speed', 'Speed', 4), k('int', 'Intensity', 6), sel('mode', 'Mode', ['Chorus', 'Vibrato'])] },
  { id: 'rotary',  cat: 'mod', name: 'Rotary',   dsp: 7, params: [sel('speed', 'Vitesse', ['Slow', 'Fast']), k('drive', 'Drive', 3), pct('mix', 'Mix', 100), k('horn', 'Horn/Drum', 5)] },

  { id: 'octave', cat: 'pitch', name: 'Octaver',     dsp: 7, params: [pct('o1', 'Oct −1', 50), pct('o2', 'Oct −2', 0), pct('up', 'Oct +1', 0), pct('dry', 'Dry', 100)] },
  { id: 'shift',  cat: 'pitch', name: 'Pitch Shift', dsp: 7, params: [k('semi', 'Demi-tons', 12, -24, 24, 1, 'st'), k('cent', 'Détune', 0, -50, 50, 1, 'ct'), pct('mix', 'Mix', 50)] },
  { id: 'harm',   cat: 'pitch', name: 'Harmonizer',  dsp: 7, params: [sel('key', 'Tonalité', NOTE_NAMES), sel('scale', 'Gamme', ['Majeure', 'Mineure', 'Dorien', 'Mixo']), sel('iv', 'Intervalle', ['3ce', '4te', '5te', '6te', 'Oct']), pct('mix', 'Mix', 50)] },

  { id: 'ddl',     cat: 'delay', name: 'Digital Delay', dsp: 7, params: [ms('time', 'Time', 380, 1, 2000), pct('fb', 'Feedback', 30), pct('mix', 'Mix', 25), hz('hc', 'High Cut', 8000, 1000, 20000, 10), sel('sync', 'Sync', SYNC)] },
  { id: 'analog',  cat: 'delay', name: 'Analog Delay',  dsp: 7, params: [ms('time', 'Time', 320, 20, 600), pct('fb', 'Feedback', 35), pct('mix', 'Mix', 25), pct('mod', 'Mod', 20), sel('sync', 'Sync', SYNC)] },
  { id: 'tape',    cat: 'delay', name: 'Tape Echo',     dsp: 7, params: [ms('time', 'Time', 420, 50, 1200), pct('fb', 'Feedback', 40), pct('mix', 'Mix', 30), pct('wow', 'Wow', 25), k('age', 'Usure', 4)] },
  { id: 'pingpong',cat: 'delay', name: 'Ping Pong',     dsp: 7, params: [ms('time', 'Time', 450, 1, 2000), pct('fb', 'Feedback', 35), pct('mix', 'Mix', 30), pct('width', 'Largeur', 100), sel('sync', 'Sync', SYNC)] },
  { id: 'reverse', cat: 'delay', name: 'Reverse',       dsp: 7, params: [ms('time', 'Time', 600, 100, 2000), pct('fb', 'Feedback', 20), pct('mix', 'Mix', 40)] },

  { id: 'room',    cat: 'reverb', name: 'Room',    dsp: 20,  params: REV(0.8) },
  { id: 'hall',    cat: 'reverb', name: 'Hall',    dsp: 20, params: REV(2.8) },
  { id: 'plate',   cat: 'reverb', name: 'Plate',   dsp: 20,  params: REV(1.9) },
  { id: 'spring',  cat: 'reverb', name: 'Spring',  dsp: 20,  params: [k('dwell', 'Dwell', 5), k('tone', 'Tone', 5), pct('mix', 'Mix', 30), sel('springs', 'Ressorts', ['2', '3', '4'], 1)] },
  { id: 'shimmer', cat: 'reverb', name: 'Shimmer', dsp: 20, params: REV(6, [sel('int', 'Pitch', ['+12', '+7', '+12/+7']), pct('shim', 'Shimmer', 50)]) },

  { id: 'vol',  cat: 'util', name: 'Volume', dsp: 4, params: [db('lvl', 'Niveau', 0, -40, 12), k('pan', 'Pan', 0, -100, 100, 1, '')] },
  { id: 'fxl',  cat: 'util', name: 'Send / Return', dsp: 4, params: [db('send', 'Send'), db('ret', 'Return'), pct('mix', 'Mix', 100)] },
];

const MODEL = Object.fromEntries(MODELS.map(m => [m.id, m]));
const defaultParams = mid => Object.fromEntries(MODEL[mid].params.map(p => [p.id, p.def]));
let _uidN = 0;
const uid = () => 'b' + Date.now().toString(36).slice(-5) + (_uidN++).toString(36) + Math.random().toString(36).slice(2, 5);
const presetLabel = i => String(i + 1).padStart(2, '0');                 /* 01 … 80, sans banques */

function defaultFs(p) {
  const firstOf = cat => p.lanes.flat().find(b => b && MODEL[b.model].cat === cat);
  const drv = firstOf('drive') || firstOf('dyn'), mod = firstOf('mod') || firstOf('delay'), rev = firstOf('reverb');
  return [
    { press: drv ? 'block:' + drv.uid : 'presetDown', hold: 'presetDown', color: '#ff9f1a' },
    { press: mod ? 'block:' + mod.uid : 'tap', hold: 'tuner', color: '#3aa0ff' },
    { press: rev ? 'block:' + rev.uid : 'presetUp', hold: 'presetUp', color: '#2fd6c5' },
    { press: 'tap', hold: 'none', color: '#ff4d4d' },
  ];
}

/* laneA / laneB : listes de [modelId, overrides?, on?] alignées sur les colonnes.
 * Chaque groupe de blocs contigus sur B forme une section parallèle :
 * split juste avant sa première colonne, merge juste après la dernière.
 * p.par[colonneDeDébut] = balance A/B de la section (0 = tout A, 100 = tout B). */
function makePreset(name, color, laneA, opt = {}) {
  const p = {
    name, color, tempo: opt.tempo || 120, level: 0,
    lanes: [Array(COLS).fill(null), Array(COLS).fill(null)], par: {},
    scenes: [], scene: 0, fs: [], exp: { target: '', min: 0, max: 100, curve: 0 },
  };
  const base = {};
  const place = (spec, lane, off) => spec.forEach((s, i) => {
    if (!s) return;
    const [mid, ov = {}, on = true] = s;
    const b = { uid: uid(), model: mid };
    p.lanes[lane][off + i] = b;
    base[b.uid] = { on, p: { ...defaultParams(mid), ...ov } };
  });
  place(laneA, 0, 0);
  if (opt.laneB) place(opt.laneB, 1, 0);
  for (let i = 0; i < SCENES; i++) p.scenes.push({ name: SCENE_NAMES[i], state: JSON.parse(JSON.stringify(base)) });
  /* Variantes : Lead = drives/boost ON + delay ON ; Clean = drives OFF ; Solo = Lead + reverb plus large */
  for (const b of p.lanes.flat()) {
    if (!b) continue;
    const cat = MODEL[b.model].cat;
    const L = p.scenes[1].state[b.uid], C = p.scenes[2].state[b.uid], S = p.scenes[3].state[b.uid];
    if (cat === 'drive' || b.model === 'boost') { L.on = true; S.on = true; C.on = false; }
    if (cat === 'delay') { L.on = true; S.on = true; S.p.mix = Math.min(100, (S.p.mix || 25) + 10); }
    if (cat === 'amp') { S.p.gain = Math.min(10, +(S.p.gain + 1.5).toFixed(1)); C.p.gain = Math.max(0, +(C.p.gain - 2).toFixed(1)); }
    if (cat === 'reverb' && 'mix' in S.p) S.p.mix = Math.min(100, S.p.mix + 15);
  }
  p.fs = defaultFs(p);
  return p;
}

function initPreset() { return makePreset('Init', '#9aa3ad', [['gate'], ['brit'], ['cab412']]); }

function setScene(p, i, uid, on, over) {
  const st = p.scenes[i].state[uid];
  if (!st) return;
  st.on = !!on;
  if (over) Object.assign(st.p, over);
}
function renameScenes(p, names) { names.forEach((n, i) => { if (p.scenes[i]) p.scenes[i].name = n; }); }

/* Stairway : un seul Plexi ; gain bas (intro, couplets) ou haut + boost (lead, solo) selon la scène. */
function stairwayPreset() {
  const p = makePreset('Stairway to Heaven', '#f5d90a', [
    ['boost', { gain: 4, tone: 6 }, false],
    ['plexi', { gain: 2.5, bass: 5, mid: 5.5, treb: 6.5, pres: 5, mast: 5, jump: 2 }],
    ['cab412', { mic: 1, pos: 4, dist: 2 }],
    ['ddl', { time: 430, fb: 25, mix: 15 }],
    ['plate', { decay: 2.4, pre: 30, mix: 22, tone: 5, lc: 100 }],
  ], { tempo: 82 });
  const bo = p.lanes[0][0].uid, px = p.lanes[0][1].uid;
  const clean = [0, 2, 4, 5, 6, 7];
  for (let i = 0; i < SCENES; i++) {
    const c = clean.includes(i);
    setScene(p, i, px, true, { gain: c ? 2.5 : 6.5 });
    setScene(p, i, bo, !c, { gain: 4 });
  }
  renameScenes(p, ['Intro', 'Lead', 'Clean', 'Solo', 'Verse', 'Chorus', 'Bridge', 'Outro']);
  return p;
}

/* 20 sons stock inspirés de classiques, avec uniquement les modèles du firmware
 * (pas de NAM ni d'IR à charger : baffles d'usine intégrés ; le gate d'entrée global remplace les blocs Gate,
 * gardés seulement en métal). Budget DSP de chacun <= 100 %. */
function factoryPresets() {
  const list = [
    makePreset('Appetite for Destruction', '#ff4d4d', [
      ['green', { drv: 3.5, tone: 5.5, lvl: 6 }, false],
      ['brit', { gain: 7, bass: 5, mid: 6.5, treb: 6, pres: 5.5, mast: 6 }],
      ['cab412', { mic: 0, pos: 3, dist: 2 }],
      ['ddl', { time: 420, fb: 30, mix: 18 }], ['hall', { decay: 2.2, pre: 20, mix: 18, tone: 5, lc: 100 }],
    ], { tempo: 125 }),
    stairwayPreset(),
    makePreset('Purple Rain', '#b06cff', [
      ['usclean', { gain: 4, bass: 5, mid: 4, treb: 6.5, pres: 4.5, mast: 5, bright: true }],
      ['cab212', { mic: 0, pos: 4, dist: 2 }],
      ['chorus', { rate: 0.6, depth: 45, mix: 40, tone: 5 }],
      ['analog', { time: 360, fb: 38, mix: 28, mod: 25 }],
      ['plate', { decay: 2.8, pre: 30, mix: 30, tone: 5, lc: 100 }],
    ], { tempo: 70 }),
    makePreset('Comfortably Numb', '#3aa0ff', [
      ['muff', { sus: 5.5, tone: 5, vol: 5 }, false],
      ['brit', { gain: 5, bass: 5, mid: 5.5, treb: 5.5, pres: 5, mast: 6 }],
      ['cab412', { mic: 0, pos: 3, dist: 2 }],
      ['ddl', { time: 480, fb: 42, mix: 26 }], ['hall', { decay: 3.2, pre: 30, mix: 25, tone: 4.5, lc: 100 }],
    ], { tempo: 63 }),
    makePreset('Back in Black', '#9aa3ad', [
      ['green', { drv: 2, tone: 5, lvl: 5.5 }, false],
      ['plexi', { gain: 6.5, bass: 5, mid: 6, treb: 6.5, pres: 5, mast: 5.5, jump: 2 }],
      ['cab412', { mic: 1, pos: 3, dist: 2 }], ['room', { decay: 0.7, pre: 10, mix: 12, tone: 5, lc: 120 }],
    ], { tempo: 118 }),
    makePreset('Smells Like Teen Spirit', '#3ddc84', [
      ['muff', { sus: 6.5, tone: 4.5, vol: 6 }],
      ['brit', { gain: 5.5, bass: 5, mid: 4, treb: 5.5, pres: 5, mast: 5.5 }],
      ['cab412', { mic: 0, pos: 2, dist: 1.5 }], ['room', { decay: 0.8, pre: 10, mix: 14, tone: 4.5, lc: 120 }],
    ], { tempo: 117 }),
    makePreset('Master of Puppets', '#ff9f1a', [
      ['gate', { thr: -40, rel: 40 }], ['green', { drv: 1.5, tone: 5.5, lvl: 7 }],
      ['rect', { gain: 8, bass: 6, mid: 3.5, treb: 6, pres: 6, mast: 5, mode: 2, rect: 1 }],
      ['cab412', { mic: 2, pos: 2, dist: 1.5 }], ['ddl', { time: 380, fb: 20, mix: 12 }],
    ], { tempo: 212 }),
    makePreset('Voodoo Child', '#ff5fb0', [
      ['fuzz', { fuzz: 7, vol: 5, germ: true }],
      ['plexi', { gain: 5, bass: 5, mid: 6, treb: 6, pres: 5, mast: 5.5, jump: 2 }],
      ['cab412', { mic: 1, pos: 3, dist: 2 }], ['vibe', { speed: 4, int: 6, mode: 0 }],
      ['spring', { dwell: 6, tone: 5.5, mix: 30, springs: 1 }],
    ], { tempo: 90 }),
    makePreset('Pride and Joy', '#2fd6c5', [
      ['green', { drv: 2.5, tone: 6, lvl: 6 }],
      ['usclean', { gain: 4.5, bass: 5, mid: 4.5, treb: 6, pres: 4.5, mast: 5, bright: true }],
      ['cab212', { mic: 5, pos: 4, dist: 2 }], ['spring', { dwell: 7, tone: 5, mix: 28, springs: 2 }],
    ], { tempo: 110 }),
    makePreset('Hotel California', '#f5d90a', [
      ['green', { drv: 2, tone: 5.5, lvl: 5.5 }, false],
      ['usclean', { gain: 4, bass: 5, mid: 4.5, treb: 6, pres: 4.5, mast: 5, bright: true }],
      ['cab212', { mic: 2, pos: 4, dist: 2 }],
      ['ddl', { time: 420, fb: 25, mix: 16 }], ['plate', { decay: 2.2, pre: 30, mix: 22, tone: 5, lc: 100 }],
    ], { tempo: 75 }),
    makePreset('Purple Haze', '#b06cff', [
      ['fuzz', { fuzz: 7.5, vol: 5, germ: true }],
      ['octave', { o1: 35, o2: 0, up: 0, dry: 100 }],
      ['plexi', { gain: 5.5, bass: 5, mid: 6, treb: 6, pres: 5, mast: 5.5, jump: 2 }],
      ['cab412', { mic: 1, pos: 3, dist: 2 }], ['vibe', { speed: 5, int: 7, mode: 0 }],
      ['spring', { dwell: 6, tone: 5.5, mix: 30, springs: 1 }],
    ], { tempo: 100 }),
    makePreset('Bohemian Rhapsody', '#ff9f1a', [
      ['boost', { gain: 5, tone: 6.5 }],
      ['chime', { gain: 5.5, bass: 5, mid: 5.5, treb: 6.5, pres: 3, mast: 5, ch: 1 }],
      ['cab212', { mic: 0, pos: 4, dist: 2 }],
      ['ddl', { time: 400, fb: 30, mix: 20 }], ['plate', { decay: 2.5, pre: 30, mix: 24, tone: 5, lc: 100 }],
      ['harm', { key: 9, scale: 0, iv: 2, mix: 30 }],
    ], { tempo: 72 }),
    makePreset('Little Wing', '#3ddc84', [
      ['usclean', { gain: 3.5, bass: 5, mid: 4.5, treb: 6, pres: 4, mast: 5, bright: true }],
      ['cab412', { mic: 4, pos: 4, dist: 2 }],
      ['vibe', { speed: 3, int: 5, mode: 0 }], ['chorus', { rate: 0.4, depth: 25, mix: 20, tone: 5 }],
      ['spring', { dwell: 6, tone: 5, mix: 24, springs: 1 }],
    ], { tempo: 70 }),
    makePreset('Wish You Were Here', '#2fd6c5', [
      ['usclean', { gain: 3.5, bass: 5, mid: 4.5, treb: 6, pres: 4, mast: 5, bright: true }],
      ['cab212', { mic: 1, pos: 4, dist: 2 }],
      ['chorus', { rate: 0.45, depth: 30, mix: 22, tone: 5 }],
      ['ddl', { time: 460, fb: 30, mix: 18 }], ['plate', { decay: 2.4, pre: 30, mix: 24, tone: 5, lc: 100 }],
      ['peq', { lf: 1, lmf: -1, lmq: 400, hmf: 1.5, hmq: 2500, hf: 1, lvl: 0 }],
    ], { tempo: 60 }),
    makePreset('Enter Sandman', '#ff4d4d', [
      ['gate', { thr: -40, rel: 40 }], ['green', { drv: 1.5, tone: 5.5, lvl: 7 }],
      ['lead51', { gain: 8, bass: 6, mid: 4, treb: 6, pres: 6, mast: 5, res: 5.5 }],
      ['cab412', { mic: 2, pos: 2, dist: 1.5 }], ['ddl', { time: 420, fb: 25, mix: 14 }],
    ], { tempo: 123 }),
    makePreset("Sweet Child O' Mine", '#ff9f1a', [
      ['green', { drv: 3, tone: 5.5, lvl: 6 }],
      ['brit', { gain: 7, bass: 5, mid: 6.5, treb: 6, pres: 5.5, mast: 6 }],
      ['cab412', { mic: 0, pos: 3, dist: 2 }], ['analog', { time: 420, fb: 35, mix: 22, mod: 20 }],
      ['hall', { decay: 2.6, pre: 25, mix: 22, tone: 5, lc: 100 }],
    ], { tempo: 126 }),
    makePreset('Whole Lotta Love', '#9aa3ad', [
      ['fuzz', { fuzz: 6.5, vol: 5, germ: true }],
      ['plexi', { gain: 5.5, bass: 5, mid: 6, treb: 6, pres: 5, mast: 5.5, jump: 2 }],
      ['cab412', { mic: 1, pos: 3, dist: 2 }], ['room', { decay: 0.9, pre: 10, mix: 15, tone: 5, lc: 120 }],
    ], { tempo: 90 }),
    makePreset('Sunshine of Your Love', '#3aa0ff', [
      ['green', { drv: 2.5, tone: 5.5, lvl: 6 }],
      ['plexi', { gain: 5, bass: 5, mid: 6, treb: 6, pres: 5, mast: 5.5, jump: 2 }],
      ['cab412', { mic: 1, pos: 3, dist: 2 }], ['room', { decay: 0.8, pre: 10, mix: 14, tone: 5, lc: 120 }],
    ], { tempo: 116 }),
    makePreset('Kashmir', '#b06cff', [
      ['muff', { sus: 5, tone: 5, vol: 5.5 }],
      ['plexi', { gain: 5.5, bass: 5, mid: 6, treb: 5.5, pres: 5, mast: 5.5, jump: 2 }],
      ['cab412', { mic: 1, pos: 3, dist: 2 }], ['ddl', { time: 450, fb: 25, mix: 15 }],
      ['hall', { decay: 2.8, pre: 25, mix: 20, tone: 4.5, lc: 100 }],
    ], { tempo: 80 }),
    makePreset('Beat It', '#ff5fb0', [
      ['green', { drv: 3, tone: 5.5, lvl: 6 }],
      ['brit', { gain: 7, bass: 5, mid: 6, treb: 6, pres: 5.5, mast: 6 }],
      ['cab412', { mic: 0, pos: 3, dist: 2 }], ['ddl', { time: 400, fb: 30, mix: 18 }],
      ['hall', { decay: 2.4, pre: 25, mix: 20, tone: 5, lc: 100 }],
    ], { tempo: 139 }),
  ];
  const out = [];
  for (let i = 0; i < PRESETS; i++) out.push(list[i] || initPreset());
  return out;
}

/* ---- IR de démo (synthétiques, déterministes) ---- */
const IR_FACTORY = ['4x12 V30 · SM57', '4x12 Greenback · R121', '2x12 Blue · 57+121', '1x12 Jensen · Cond', '4x10 Bass · D112', 'Acoustic Body · Dread', '2x12 Silver · Fat', '4x12 Modern · Mix'];

function mulberry32(a) { return () => { a |= 0; a = a + 0x6D2B79F5 | 0; let t = Math.imul(a ^ a >>> 15, 1 | a); t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t; return ((t ^ t >>> 14) >>> 0) / 4294967296; }; }

function synthIR(seed, len = 2048, rate = 48000) {
  const r = mulberry32(seed * 7919 + 13), x = new Float32Array(len);
  const tau = 70 + (seed % 5) * 30, a = 0.18 + (seed % 7) * 0.07;
  const peaks = [1800 + (seed % 4) * 600, 3200 + (seed % 3) * 900];
  let lp = 0, slow = 0, max = 0;
  for (let n = 0; n < len; n++) {
    const env = Math.exp(-n / tau);
    let s = (r() * 2 - 1) * env + (n === 2 ? 1.4 : 0);
    lp += a * (s - lp);
    slow += 0.012 * (lp - slow);
    let y = lp - slow * 0.9;
    for (let j = 0; j < peaks.length; j++) y += 0.25 * Math.exp(-n / 26) * Math.sin(2 * Math.PI * peaks[j] * n / rate);
    x[n] = y;
    max = Math.max(max, Math.abs(y));
  }
  for (let n = 0; n < len; n++) x[n] /= max || 1;
  return x;
}

function factoryIRs() {
  const out = Array(IR_SLOTS).fill(null);
  IR_FACTORY.forEach((name, i) => { out[i] = { name, synth: i + 1, rate: 48000, len: 2048 }; });
  return out;
}
